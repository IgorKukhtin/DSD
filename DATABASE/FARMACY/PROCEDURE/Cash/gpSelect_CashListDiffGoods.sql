-- Function: gpSelect_CashListDiffGoods()

--DROP FUNCTION IF EXISTS gpSelect_CashListDiffGoods (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_CashListDiffGoods (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_CashListDiffGoods(
    IN inGoodsID       Integer,    -- Медикамент
    IN inDiffKindID    Integer,    -- Видах отказа
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id               Integer,
               AmountDiffUser   TFloat,
               AmountDiff       TFloat,
               AmountDiffPrev   TFloat,
               AmountDiffKind   TFloat,
               AmountIncome TFloat, PriceSaleIncome TFloat,
               ListDate TDateTime,
               AmountSendIn TFloat
              )

AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbObjectId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_ListDiff());
     vbUserId:= lpGetUserBySession (inSession);

    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');


    -- поиск <Торговой сети>
    vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

    IF vbUnitKey = '' THEN
       vbUnitKey := '0';
    END IF;
    vbUnitId := vbUnitKey ::Integer;


     RETURN QUERY
     WITH
          tmpIncome AS (SELECT MI_Income.ObjectId                      AS GoodsId
                             , SUM(COALESCE (MI_Income.Amount, 0))     AS AmountIncome
                             , SUM(COALESCE (MI_Income.Amount, 0) * COALESCE(MIFloat_PriceSale.ValueData,0))  AS SummSale
                        FROM Movement AS Movement_Income
                             INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                           ON MovementLinkObject_To.MovementId = Movement_Income.Id
                                                          AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                          AND MovementLinkObject_To.ObjectId = vbUnitId

                             LEFT JOIN MovementItem AS MI_Income
                                                    ON MI_Income.MovementId = Movement_Income.Id
                                                   AND MI_Income.isErased   = False

                             LEFT JOIN MovementItemFloat AS MIFloat_PriceSale
                                                         ON MIFloat_PriceSale.MovementItemId = MI_Income.Id
                                                        AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()

                         WHERE Movement_Income.DescId = zc_Movement_Income()
                           AND Movement_Income.StatusId = zc_Enum_Status_UnComplete()
                           AND Movement_Income.OperDate >= CURRENT_DATE - INTERVAL '6 MONTH'
                           AND MI_Income.ObjectId = inGoodsID
                         GROUP BY MI_Income.ObjectId, MovementLinkObject_To.ObjectId
                      )
        , tmpMovement AS (SELECT MovementItem.ObjectId                                                                               AS Id,
                                 SUM(CASE WHEN Movement.OperDate >= CURRENT_DATE::TDateTime AND
                                     MILO_Insert.ObjectId = vbUserId THEN MovementItem.Amount END)::TFloat                           AS AmountDiffUser,
                                 SUM(CASE WHEN Movement.OperDate >= CURRENT_DATE::TDateTime THEN MovementItem.Amount END)::TFloat    AS AmountDiff,
                                 SUM(CASE WHEN Movement.OperDate < CURRENT_DATE::TDateTime THEN MovementItem.Amount END)::TFloat     AS AmountDiffPrev,
                                 SUM(CASE WHEN Movement.OperDate >= CURRENT_DATE::TDateTime AND
                                     MILO_DiffKind.ObjectId = inDiffKindID THEN MovementItem.Amount END)::TFloat                     AS AmountDiffKind
                          FROM Movement
                               INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                            ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                           AND MovementLinkObject_UNit.DescId = zc_MovementLinkObject_Unit()
                                                           AND MovementLinkObject_Unit.ObjectId = vbUnitId

                               LEFT JOIN MovementItem ON MovementItem.MovementID = Movement.Id

                               LEFT JOIN MovementItemLinkObject AS MILO_Insert
                                                                ON MILO_Insert.MovementItemId = MovementItem.Id
                                                               AND MILO_Insert.DescId = zc_MILinkObject_Insert()

                               LEFT JOIN MovementItemLinkObject AS MILO_DiffKind
                                                                ON MILO_DiffKind.MovementItemId = MovementItem.Id
                                                               AND MILO_DiffKind.DescId = zc_MILinkObject_DiffKind()

                          WHERE Movement.OperDate >= (CURRENT_DATE - interval '1 day')::TDateTime
                            AND Movement.DescId = zc_Movement_ListDiff()
                            AND  MovementItem.ObjectId = inGoodsID
                          GROUP BY MovementItem.ObjectId)
        , tmpListDate AS (SELECT MovementItem.ObjectId         AS GoodsID
                               , MAX(MIDate_List.ValueData)    AS ListDate
                          FROM Movement

                               INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                            ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                           AND MovementLinkObject_UNit.DescId = zc_MovementLinkObject_Unit()
                                                           AND MovementLinkObject_Unit.ObjectId = vbUnitId

                               INNER JOIN MovementItem AS MovementItem
                                                       ON MovementItem.MovementId = Movement.Id
                                                      AND MovementItem.DescId     = zc_MI_Master()
                                                      AND MovementItem.isErased   = False
                                                      AND MovementItem.ObjectId   = inGoodsID

                               LEFT JOIN MovementItemDate AS MIDate_List
                                                          ON MIDate_List.MovementItemId = MovementItem.Id
                                                         AND MIDate_List.DescId = zc_MIDate_List()

                          WHERE Movement.DescId = zc_Movement_ListDiff()
                            AND Movement.StatusId in (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete())
                          GROUP BY MovementItem.ObjectId)
              -- Отложенные перемещения
         , tmpMovementID AS (SELECT Movement.Id
                             FROM Movement
                             WHERE Movement.DescId = zc_Movement_Send()
                              AND Movement.StatusId = zc_Enum_Status_UnComplete()
                            )
         , tmpMovementSend AS (SELECT Movement.Id
                               FROM tmpMovementID AS Movement

                                    INNER JOIN MovementBoolean AS MovementBoolean_Deferred
                                                               ON MovementBoolean_Deferred.MovementId = Movement.Id
                                                              AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()
                                                              AND MovementBoolean_Deferred.ValueData = TRUE
                                                                      
                                    INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                  ON MovementLinkObject_To.MovementId = Movement.Id
                                                                 AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                                 AND MovementLinkObject_To.ObjectId = vbUnitId
                               )
         , tmpDeferredSendIn AS (SELECT Container.ObjectId                  AS GoodsId
                                      , SUM(- MovementItemContainer.Amount) AS Amount
                                 FROM tmpMovementSend AS Movement
               
                                      INNER JOIN MovementItemContainer ON MovementItemContainer.MovementId = Movement.Id
                                                                      AND MovementItemContainer.DescId = zc_Container_Count()
               
                                      INNER JOIN Container ON Container.Id = MovementItemContainer.ContainerId
                                                
                                 GROUP BY Container.ObjectId
                               )


       SELECT Object_Goods.ID
            , tmpMovement.AmountDiffUser
            , tmpMovement.AmountDiff
            , tmpMovement.AmountDiffPrev
            , tmpMovement.AmountDiffKind
            , COALESCE(tmpIncome.AmountIncome,0):: TFloat               AS AmountIncome
            , CASE WHEN COALESCE(tmpIncome.AmountIncome,0) <> 0 THEN COALESCE(tmpIncome.SummSale,0) / COALESCE(tmpIncome.AmountIncome,0) ELSE 0 END  :: TFloat AS PriceSaleIncome
            , tmpListDate.ListDate::TDateTime                           AS ListDate
            , tmpDeferredSendIn.Amount :: TFloat                        AS AmountSendIn 
       FROM Object AS Object_Goods
            LEFT JOIN tmpMovement ON tmpMovement.Id = Object_Goods.Id
            LEFT JOIN tmpIncome ON tmpIncome.GoodsId = Object_Goods.Id
            LEFT JOIN tmpListDate ON tmpListDate.GoodsId = Object_Goods.Id
            LEFT JOIN tmpDeferredSendIn ON tmpDeferredSendIn.GoodsId = Object_Goods.Id
       WHERE Object_Goods.ID = inGoodsID;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 20.02.20                                                      *
 06.06.19                                                      *
 10.02.19                                                      *
 19.11.18                                                      *
*/

-- тест
--
-- SELECT * FROM gpSelect_CashListDiffGoods (inGoodsID := 1, inSession:= '3')
-- select * from gpSelect_CashListDiffGoods(inGoodsId := 8563 , inDiffKindID := 0,  inSession := '3354092');