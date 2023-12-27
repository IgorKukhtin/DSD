-- Function: gpSelect_Movement_OrderInternal_PrintSticker (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Movement_OrderInternal_PrintSticker (Integer, Integer, BooLean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_OrderInternal_PrintSticker (Integer, BooLean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_OrderInternal_PrintSticker(
    IN inMovementId        Integer   ,   -- ключ Документа
   -- IN inMovementItemId    Integer   ,   -- ключ    
    IN inSession           TVarChar      -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE Cursor1 refcursor;
    DECLARE vbDescId Integer;
    DECLARE vbStatusId Integer;
    DECLARE vbOperDate TDateTime;
    DECLARE vbFromCode Integer;
    DECLARE vbFromName TVarChar;

BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
     vbUserId:= lpGetUserBySession (inSession);

     -- параметры из документа
     SELECT Movement.DescId, Movement.StatusId, Movement.OperDate
   INTO vbDescId, vbStatusId, vbOperDate
     FROM Movement
         LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                      ON MovementLinkObject_From.MovementId = Movement.Id
                                     AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
         LEFT JOIN Object AS Object_From   ON Object_From.Id   = MovementLinkObject_From.ObjectId
     WHERE Movement.Id = inMovementId;

     -- проверка - с каким статусом можно печатать
    IF COALESCE (vbStatusId, 0) <> zc_Enum_Status_Complete() AND 1=0
    THEN
        IF vbStatusId = zc_Enum_Status_Erased()
        THEN
            RAISE EXCEPTION 'Ошибка.Документ <%> № <%> от <%> удален.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
        END IF;
        IF vbStatusId = zc_Enum_Status_UnComplete()
        THEN
            RAISE EXCEPTION 'Ошибка.Документ <%> № <%> от <%> не проведен.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
        END IF;
    END IF;

     -- Результат
     OPEN Cursor1 FOR
       WITH tmpMI AS (SELECT MovementItem.Id
                           , MovementItem.ObjectId   AS GoodsId
                      FROM MovementItem
                      WHERE MovementItem.MovementId = inMovementId
                        AND MovementItem.DescId     = zc_MI_Master()
                        AND MovementItem.isErased   = FALSE
                        AND MovementItem.Amount     <> 0
                        --AND (MovementItem.Id = inMovementItemId OR COALESCE (inMovementItemId, 0) = 0)
                     )  
           
       -- Результат
       SELECT
             tmpMI.Id
           , Object_Goods.Id                AS GoodsId
           , Object_Goods.ObjectCode        AS GoodsCode
           , Object_Goods.ValueData         AS GoodsName
           , zfFormat_BarCode (zc_BarCodePref_MI(), tmpMI.Id) AS IdBarCode
           , ObjectString_Article.ValueData AS Article
           , zfCalc_InvNumber_isErased ('', Movement_OrderClient.InvNumber, Movement_OrderClient.OperDate, Movement_OrderClient.StatusId) AS InvNumberFull_OrderClient 
           , Movement_OrderClient.InvNumber  AS InvNumber_OrderClient  
           , (Object_Brand.ValueData || '-' || Object_Model.ValueData) ::TVarChar AS ModelName_full
           , ObjectDate_DateBegin.ValueData ::Date   AS DateBegin 
           , COALESCE (MovementFloat_NPP.ValueData,0) :: Integer AS NPP
           
       FROM tmpMI
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId

            LEFT JOIN ObjectString AS ObjectString_Article
                                   ON ObjectString_Article.ObjectId = tmpMI.GoodsId
                                  AND ObjectString_Article.DescId = zc_ObjectString_Article()
            LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                        ON MIFloat_MovementId.MovementItemId = tmpMI.Id
                                       AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId() 
            LEFT JOIN Movement AS Movement_OrderClient ON Movement_OrderClient.Id = MIFloat_MovementId.ValueData :: Integer

            LEFT JOIN MovementFloat AS MovementFloat_NPP
                                    ON MovementFloat_NPP.MovementId = Movement_OrderClient.Id
                                   AND MovementFloat_NPP.DescId = zc_MovementFloat_NPP()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Product
                                         ON MovementLinkObject_Product.MovementId = Movement_OrderClient.Id
                                        AND MovementLinkObject_Product.DescId = zc_MovementLinkObject_Product()
            LEFT JOIN Object AS Object_Product ON Object_Product.Id = MovementLinkObject_Product.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Model
                                 ON ObjectLink_Model.ObjectId = Object_Product.Id
                                AND ObjectLink_Model.DescId = zc_ObjectLink_Product_Model()
            LEFT JOIN Object AS Object_Model ON Object_Model.Id = ObjectLink_Model.ChildObjectId
            LEFT JOIN ObjectLink AS ObjectLink_Brand
                                 ON ObjectLink_Brand.ObjectId = Object_Product.Id
                                AND ObjectLink_Brand.DescId = zc_ObjectLink_Product_Brand()
            LEFT JOIN Object AS Object_Brand ON Object_Brand.Id = ObjectLink_Brand.ChildObjectId  

            LEFT JOIN ObjectDate AS ObjectDate_DateBegin
                                 ON ObjectDate_DateBegin.ObjectId = Object_Product.Id
                                AND ObjectDate_DateBegin.DescId = zc_ObjectDate_Product_DateBegin()                                     
       ORDER BY Object_Goods.ValueData
       ;

    RETURN NEXT Cursor1;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
27.12.23          *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_OrderInternal_PrintSticker (inMovementId:= 432692, inMovementItemId:= 0, inSession:= '5');
