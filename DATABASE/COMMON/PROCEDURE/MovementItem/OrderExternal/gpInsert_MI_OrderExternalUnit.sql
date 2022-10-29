-- Function: gpInsert_MI_OrderExternalUnit()

DROP FUNCTION IF EXISTS gpInsert_MI_OrderExternalUnit (Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpInsert_MI_OrderExternalUnit(
    IN inMovementId      Integer      , -- ключ Документа
    IN inSession         TVarChar       -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbOperDate TDateTime;
   DECLARE vbOperDatePartner TDateTime;
   DECLARE vbFromId Integer;
   DECLARE vbRetailId Integer;
   DECLARE vbPartnerId Integer;
BEGIN
--return;
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_OrderExternalUnit());


      -- Проверка - что б не копировали два раза
      IF EXISTS (SELECT Id FROM MovementItem WHERE isErased = FALSE AND DescId = zc_MI_Master() AND MovementId = inMovementId AND Amount <> 0)
         THEN RAISE EXCEPTION 'Ошибка.В документе уже есть данные.'; 
      END IF;

     -- данные из документа 
      SELECT Movement.OperDate                 AS OperDate
           , MD_OperDatePartner.ValueData      AS OperDatePartner
           , MLO_From.ObjectId                 AS FromId
           , COALESCE(MLO_Retail.ObjectId,0)               AS RetailId
           , COALESCE(MLO_Partner.ObjectId,0)              AS PartnerId
         INTO  vbOperDate, vbOperDatePartner, vbFromId, vbRetailId, vbPartnerId
      FROM Movement 
            LEFT JOIN MovementDate AS MD_OperDatePartner
                                   ON MD_OperDatePartner.MovementId =  Movement.Id
                                  AND MD_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

            LEFT JOIN MovementLinkObject AS MLO_From
                                         ON MLO_From.MovementId = Movement.Id
                                        AND MLO_From.DescId = zc_MovementLinkObject_From()

            LEFT JOIN MovementLinkObject AS MLO_Retail
                                         ON MLO_Retail.MovementId = Movement.Id
                                        AND MLO_Retail.DescId = zc_MovementLinkObject_Retail()
           
            LEFT JOIN MovementLinkObject AS MLO_Partner
                                         ON MLO_Partner.MovementId = Movement.Id
                                        AND MLO_Partner.DescId = zc_MovementLinkObject_Partner()
      WHERE Movement.Id = inMovementId;
               
       -- Результат
       CREATE TEMP TABLE tmpMI (GoodsId Integer, GoodsKindId Integer
                              , Amount TFloat, AmountSecond TFloat
                              , Price TFloat, CountForPrice TFloat
                               ) ON COMMIT DROP;
                           
   WITH tmpPartner AS (SELECT Object.Id AS PartnerId
                       FROM Object
                       WHERE (vbPartnerId > 0 and Object.Id = vbPartnerId)
                          OR (vbPartnerId = 0 and vbRetailId = 0)
                         AND Object.descid = zc_Object_Partner()
                      UNION 
                       SELECT ObjectLink_Partner_Juridical.ObjectId AS PartnerId
                       FROM ObjectLink AS ObjectLink_Juridical_Retail
                           LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                ON ObjectLink_Partner_Juridical.ChildObjectId = ObjectLink_Juridical_Retail.ObjectId
                                               AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                       WHERE ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                         AND ObjectLink_Juridical_Retail.ChildObjectId <> 0
                         AND ObjectLink_Juridical_Retail.ChildObjectId = vbRetailId
                         AND vbPartnerId = 0 AND vbRetailId > 0
                             
                               )
      , tmpOrderExternal AS (SELECT DISTINCT Movement.Id AS MovementId
                             FROM Movement
                               LEFT JOIN MovementLinkObject AS MLO_From
                                                            ON MLO_From.MovementId = Movement.Id
                                                           AND MLO_From.DescId = zc_MovementLinkObject_From()
                               INNER JOIN tmpPartner ON tmpPartner.PartnerId = MLO_From.ObjectId
                              
                               LEFT JOIN MovementLinkObject AS MLO_To
                                                            ON MLO_To.MovementId = Movement.Id
                                                           AND MLO_To.DescId = zc_MovementLinkObject_To()
           
                             WHERE Movement.OperDate = vbOperDate
                               AND Movement.DescId = zc_Movement_OrderExternal() AND Movement.StatusId = zc_Enum_Status_Complete()
                               AND MLO_To.ObjectId = vbFromId
                       )
                       
                                                
      INSERT INTO tmpMI  (GoodsId, GoodsKindId, Amount, AmountSecond
                        , Price, CountForPrice
                         )
                           SELECT  MovementItem.ObjectId                         AS GoodsId
                                 , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                                 , SUM(MovementItem.Amount)                :: TFloat       AS Amount
                                 , SUM(MIFloat_AmountSecond.ValueData)     :: TFloat       AS AmountSecond
                                 , COALESCE (MIFloat_Price.ValueData, 0)   :: TFloat       AS Price
                                 , CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END :: TFloat AS CountForPrice
                                 
                            FROM MovementItem 
                                 LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                  ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                 AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                 LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                             ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                            AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                 LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                             ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                            AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                                 LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                                             ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                                            AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
                                                            
                            WHERE MovementItem.MovementId in (SELECT tmpOrderExternal.MovementId FROM tmpOrderExternal)
                              AND MovementItem.DescId     = zc_MI_Master()
                              AND MovementItem.isErased   = FALSE
                            GROUP BY MovementItem.ObjectId
                                   , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                                   , COALESCE (MIFloat_Price.ValueData, 0)
                                   , CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END
 ;

   -- сохранили
   PERFORM gpInsertUpdate_MovementItem_OrderExternal (ioId                 := 0 :: integer
                                                    , inMovementId         := inMovementId
                                                    , inGoodsId            := tmpMI.GoodsId
                                                    , inAmount             := COALESCE (tmpMI.Amount,0) :: TFloat 
                                                    , inAmountSecond       := COALESCE (tmpMI.AmountSecond,0) :: TFloat 
                                                    , inGoodsKindId        := tmpMI.GoodsKindId
                                                    , ioPrice              := tmpMI.Price
                                                    , ioCountForPrice      := tmpMI.CountForPrice
                                                    , inSession            := inSession
                                                    )
     FROM tmpMI
    ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 25.12.15         *
*/

-- тест
-- select * from gpInsert_MI_OrderExternalUnit (inMovementId:= 393522 , inMovementMaskId :=393501 ,  inSession := '5');
