-- Function: gpInsert_MI_OrderPartner_byOrderClient()

DROP FUNCTION IF EXISTS gpInsert_MI_OrderPartner_byOrderClient(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_MI_OrderPartner_byOrderClient(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbFromId Integer;
   DECLARE vbToId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_OrderPartner());
     vbUserId := lpGetUserBySession (inSession);
    
    --проверка, если  есть строки в док то ошибка
    IF EXISTS (SELECT 1 FROM MovementItem WHERE MovementItem.MovementId = inMovementId AND MovementItem.isErased = FALSE AND MovementItem.DescId = zc_MI_Master())
    THEN
         RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка.Строки документа уже заполнены' :: TVarChar
                                               , inProcedureName := 'gpInsert_MI_OrderPartner_byOrderClient'   :: TVarChar
                                               , inUserId        := vbUserId);
    END IF;

    SELECT MovementLinkObject_From.ObjectId        AS FromId
         , MovementLinkObject_To.ObjectId          AS ToId
    INTO
        vbFromId
      , vbToId
    FROM Movement AS Movement_OrderPartner
        LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                     ON MovementLinkObject_From.MovementId = Movement_OrderPartner.Id
                                    AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()

        LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                     ON MovementLinkObject_To.MovementId = Movement_OrderPartner.Id
                                    AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
    WHERE Movement_OrderPartner.Id = inMovementId
      AND Movement_OrderPartner.DescId = zc_Movement_OrderPartner();
      
    --данные из zc_Movement_OrderClient.zc_MI_Child по признаку zc_MILinkObject_Partner
    CREATE TEMP TABLE _tmpMI_Child (Id Integer, ObjectId Integer, Amount TFloat, AmountPartner TFloat, OperPrice TFloat, CountForPrice TFloat) ON COMMIT DROP;
    INSERT INTO _tmpMI_Child (Id, ObjectId, Amount, AmountPartner, OperPrice, CountForPrice)
    WITH
    tmpMI AS (SELECT MovementItem.Id
                   , MovementItem.ObjectId
                   , MovementItem.Amount
              FROM MovementItemLinkObject AS MILinkObject_Partner
                   INNER JOIN MovementItem ON MovementItem.Id = MILinkObject_Partner.MovementItemId
                                          AND MovementItem.DescId     = zc_MI_Child()
                                          AND MovementItem.isErased   = FALSE
                   INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
                                      AND Movement.DescId = zc_Movement_OrderClient()
                                      AND Movement.StatusId <> zc_Enum_Status_Erased()
                    
                   LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                               ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                              AND MIFloat_MovementId.DescId = zc_MIFloat_MovementId()
              WHERE MILinkObject_Partner.ObjectId = vbToId
                AND MILinkObject_Partner.DescId   = zc_MILinkObject_Partner()
                AND (MIFloat_MovementId.ValueData ::Integer = inMovementId OR COALESCE (MIFloat_MovementId.ValueData,0) = 0)
              )
  , tmpMIFloat AS (SELECT MovementItemFloat.*
                   FROM MovementItemFloat
                   WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                     AND MovementItemFloat.DescId IN (zc_MIFloat_OperPrice()
                                                    , zc_MIFloat_AmountPartner()
                                                    , zc_MIFloat_CountForPrice()
                                                    )
                   )
      SELECT tmpMI.*
           , MIFloat_AmountPartner.ValueData ::TFloat AS AmountPartner     --Количество заказ поставщику
           , MIFloat_OperPrice.ValueData     ::TFloat AS OperPrice         -- Цена вх без НДС
           , MIFloat_CountForPrice.ValueData ::TFloat AS CountForPrice     --
      FROM tmpMI
           LEFT JOIN tmpMIFloat AS MIFloat_AmountPartner
                                ON MIFloat_AmountPartner.MovementItemId = tmpMI.Id
                               AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
           LEFT JOIN tmpMIFloat AS MIFloat_OperPrice
                                ON MIFloat_OperPrice.MovementItemId = tmpMI.Id
                               AND MIFloat_OperPrice.DescId = zc_MIFloat_OperPrice()
           LEFT JOIN tmpMIFloat AS MIFloat_CountForPrice
                                ON MIFloat_CountForPrice.MovementItemId = tmpMI.Id
                               AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
     ;

    -- создаем  zc_MI_Master() OrderPartner
    PERFORM lpInsertUpdate_MovementItem_OrderPartner (ioId         := 0                    ::Integer
                                                    , inMovementId := inMovementId         ::Integer
                                                    , inGoodsId    := tmp.ObjectId         ::Integer
                                                    , inAmount     := tmp.AmountPartner    ::TFloat
                                                    , ioOperPrice  := tmp.OperPrice        ::TFloat
                                                    , inCountForPrice := tmp.CountForPrice ::TFloat
                                                    , inComment    := ''                   ::TVarChar
                                                    , inUserId     := vbUserId             ::Integer
                                                    )
    FROM (SELECT _tmpMI_Child.ObjectId
               , _tmpMI_Child.CountForPrice
               , _tmpMI_Child.OperPrice
               , SUM (_tmpMI_Child.AmountPartner) AS AmountPartner 
          FROM _tmpMI_Child
          GROUP BY _tmpMI_Child.ObjectId
                 , _tmpMI_Child.CountForPrice
                 , _tmpMI_Child.OperPrice
          ) AS tmp
    ;
    
    --cохраняем zc_MIFloat_MovementId в док. OrderClient
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MovementId(), _tmpMI_Child.Id, inMovementId)
    FROM _tmpMI_Child
    ;


END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.04.21         *
*/

-- тест
--