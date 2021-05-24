-- Function: gpSelect_Movement_Invoice_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_Invoice_Print (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Invoice_Print(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;

    DECLARE vbDescId Integer;
    DECLARE vbStatusId Integer;
 
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);


     -- параметры из документа
     SELECT Movement.DescId
          , Movement.StatusId
     INTO vbDescId, vbStatusId
     FROM Movement
     WHERE Movement.Id = inMovementId
    ;

     -- очень важная проверка
    IF COALESCE (vbStatusId, 0) <> zc_Enum_Status_Complete()
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



      --
    OPEN Cursor1 FOR
         
         SELECT
             Movement.Id                            AS Id
           , Movement.InvNumber                     AS InvNumber
           , MovementString_InvNumberPartner.ValueData AS InvNumberPartner
           , Movement.OperDate                      AS OperDate
           , Object_Status.ObjectCode               AS StatusCode
           , Object_Status.ValueData                AS StatusName
           
           , MovementFloat_TotalCount.ValueData     AS TotalCount

           , MovementFloat_TotalSummMVAT.ValueData  AS TotalSummMVAT
           , MovementFloat_TotalSummPVAT.ValueData  AS TotalSummPVAT
           , MovementFloat_TotalSumm.ValueData      AS TotalSumm

           , MovementBoolean_PriceWithVAT.ValueData AS PriceWithVAT
           , MovementFloat_VATPercent.ValueData     AS VATPercent
           , MovementFloat_ChangePercent.ValueData  AS ChangePercent
           , MovementFloat_CurrencyValue.ValueData  AS CurrencyValue
           , MovementFloat_ParValue.ValueData       AS ParValue

           , Object_CurrencyDocument.ValueData      AS CurrencyDocumentName

           , Object_Juridical.ValueData             AS JuridicalName

           , Object_Contract.ObjectCode             AS ContractCode
           , Object_Contract.ValueData              AS ContractName

           , Object_PaidKind.Id                     AS PaidKindId
           , Object_PaidKind.ValueData              AS PaidKindName

           , MovementString_Comment.ValueData       AS Comment

       FROM Movement 
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
            
            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId = Movement.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummMVAT
                                    ON MovementFloat_TotalSummMVAT.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummMVAT.DescId = zc_MovementFloat_TotalSummMVAT()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummPVAT
                                    ON MovementFloat_TotalSummPVAT.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummPVAT.DescId = zc_MovementFloat_TotalSummPVAT()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

            LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                      ON MovementBoolean_PriceWithVAT.MovementId =  Movement.Id
                                     AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
            LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                    ON MovementFloat_VATPercent.MovementId =  Movement.Id
                                   AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
            LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                    ON MovementFloat_ChangePercent.MovementId =  Movement.Id
                                   AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()
            LEFT JOIN MovementFloat AS MovementFloat_CurrencyValue
                                    ON MovementFloat_CurrencyValue.MovementId =  Movement.Id
                                   AND MovementFloat_CurrencyValue.DescId = zc_MovementFloat_CurrencyValue()
            LEFT JOIN MovementFloat AS MovementFloat_ParValue
                                    ON MovementFloat_ParValue.MovementId = Movement.Id
                                   AND MovementFloat_ParValue.DescId = zc_MovementFloat_ParValue()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
            LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MovementLinkObject_Contract.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                         ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                        AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                         ON MovementLinkObject_Juridical.MovementId = Movement.Id
                                        AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = MovementLinkObject_Juridical.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_CurrencyDocument
                                         ON MovementLinkObject_CurrencyDocument.MovementId = Movement.Id
                                        AND MovementLinkObject_CurrencyDocument.DescId = zc_MovementLinkObject_CurrencyDocument()
            LEFT JOIN Object AS Object_CurrencyDocument ON Object_CurrencyDocument.Id = MovementLinkObject_CurrencyDocument.ObjectId
              
       WHERE Movement.Id = inMovementId
         AND Movement.DescId = zc_Movement_Invoice();
     
    RETURN NEXT Cursor1;


    OPEN Cursor2 FOR
              WITH tmpMI AS (SELECT MovementItem.Id                            AS MovementItemId
                             , COALESCE (MILinkObject_NameBefore.ObjectId, 0)  AS NameBeforeId
                             , COALESCE (MILinkObject_Goods.ObjectId, 0)       AS GoodsId
                             , COALESCE (MovementItem.ObjectId, 0)             AS MeasureId
                             , COALESCE (MILinkObject_Unit.ObjectId, 0)        AS UnitId
                             , COALESCE (MILinkObject_Asset.ObjectId, 0)       AS AssetId
                             , MovementItem.Amount                             AS Amount
                             , COALESCE (MIFloat_Price.ValueData, 0)           AS Price
                             , COALESCE (MIFloat_CountForPrice.ValueData, 1)   AS CountForPrice
                             , MovementItem.isErased
                      FROM MovementItem 
                                  LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                              ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                             AND MIFloat_Price.DescId = zc_MIFloat_Price()    
                                  LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                              ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                             AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice() 
                                  LEFT JOIN MovementItemLinkObject AS MILinkObject_NameBefore
                                                                   ON MILinkObject_NameBefore.MovementItemId = MovementItem.Id
                                                                  AND MILinkObject_NameBefore.DescId = zc_MILinkObject_NameBefore()
                                  LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                                                   ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                                                  AND MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
                                  LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                                                   ON MILinkObject_Asset.MovementItemId = MovementItem.Id
                                                                  AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset()
                                  LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                                   ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                                  AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
                     WHERE MovementItem.MovementId = inMovementId
                       AND MovementItem.DescId     = zc_MI_Master()
                       AND MovementItem.isErased   = False
                     )
   
        -- Результат такой
        SELECT
             tmpResult.MovementItemId
           , tmpResult.Amount               :: TFloat AS Amount
           , tmpResult.Price                :: TFloat AS Price
           
           , tmpResult.CountForPrice        :: TFloat AS CountForPrice 
           , CASE WHEN COALESCE(tmpResult.CountForPrice, 1) > 0
                  THEN CAST (tmpResult.Amount * COALESCE(tmpResult.Price,0) / COALESCE(tmpResult.CountForPrice, 1) AS NUMERIC (16, 2))
                  ELSE CAST (tmpResult.Amount * COALESCE(tmpResult.Price,0) AS NUMERIC (16, 2))
             END :: TFloat AS AmountSumm

           , MIString_Comment.ValueData            :: TVarChar AS Comment
         
           , Object_Goods.Id                     AS GoodsId
           , Object_Goods.ObjectCode             AS GoodsCode
           , COALESCE (Object_Goods.ValueData, '')   :: TVarChar AS GoodsName

           , Object_Measure.Id                   AS MeasureId
           , COALESCE (Object_Measure.ValueData, '') :: TVarChar AS MeasureName

           , Object_NameBefore.Id                AS NameBeforeId
           , CASE WHEN Object_NameBefore.ValueData <> '' AND COALESCE (Object_Goods.DescId, 0) <> zc_Object_Asset() THEN Object_NameBefore.ObjectCode ELSE Object_Goods.ObjectCode END :: Integer  AS NameBeforeCode
           , CASE WHEN Object_NameBefore.ValueData <> '' AND COALESCE (Object_Goods.DescId, 0) <> zc_Object_Asset() THEN Object_NameBefore.ValueData ELSE COALESCE (Object_Goods.ValueData, '') END :: TVarChar AS NameBeforeName

           , Object_Unit.Id                      AS UnitId
           , Object_Unit.ObjectCode              AS UnitCode
           , COALESCE (Object_Unit.ValueData, '') :: TVarChar AS UnitName

           , Object_Asset.Id                     AS AssetId
           , COALESCE (Object_Asset.ValueData, '') :: TVarChar AS AssetName

       FROM tmpMI AS tmpResult
            LEFT JOIN MovementItemString AS MIString_Comment
                                         ON MIString_Comment.MovementItemId = tmpResult.MovementItemId
                                        AND MIString_Comment.DescId = zc_MIString_Comment()
            LEFT JOIN Object AS Object_NameBefore ON Object_NameBefore.Id = tmpResult.NameBeforeId
            LEFT JOIN Object AS Object_Goods      ON Object_Goods.Id      = tmpResult.GoodsId
            LEFT JOIN Object AS Object_Measure    ON Object_Measure.Id    = tmpResult.MeasureId
            LEFT JOIN Object AS Object_Unit       ON Object_Unit.Id       = tmpResult.UnitId
            LEFT JOIN Object AS Object_Asset      ON Object_Asset.Id      = tmpResult.AssetId
       ;

    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_Invoice_Print (Integer,  TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 25.07.16         * 
*/

-- тест
-- SELECT * FROM gpSelect_Movement_Invoice_Print (inMovementId := 432692, inSession:= '5');
