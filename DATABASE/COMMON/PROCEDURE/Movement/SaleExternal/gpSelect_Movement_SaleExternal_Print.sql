-- Function: gpSelect_Movement_SaleExternal_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_SaleExternal_Print (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_SaleExternal_Print(
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
           , Movement.OperDate                      AS OperDate
           , Object_Status.ObjectCode               AS StatusCode
           , Object_Status.ValueData                AS StatusName
           
           , MovementFloat_TotalCount.ValueData     AS TotalCount

           , MovementFloat_TotalCountSh.ValueData   AS TotalCountSh
           , MovementFloat_TotalCountKg.ValueData   AS TotalCountKg

           , Object_From.ValueData                  AS FromName
           , Object_PartnerFrom.ValueData           AS PartnerName_from

           , Object_GoodsProperty.Id                AS GoodsPropertyId
           , Object_GoodsProperty.ValueData         AS GoodsPropertyName

           , MovementString_Comment.ValueData       AS Comment

       FROM Movement 
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
            
            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

            LEFT JOIN MovementFloat AS MovementFloat_TotalCountSh
                                    ON MovementFloat_TotalCountSh.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCountSh.DescId = zc_MovementFloat_TotalCountSh()

            LEFT JOIN MovementFloat AS MovementFloat_TotalCountKg
                                    ON MovementFloat_TotalCountKg.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCountKg.DescId = zc_MovementFloat_TotalCountKg()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_GoodsProperty
                                         ON MovementLinkObject_GoodsProperty.MovementId = Movement.Id
                                        AND MovementLinkObject_GoodsProperty.DescId = zc_MovementLinkObject_GoodsProperty()
            LEFT JOIN Object AS Object_GoodsProperty ON Object_GoodsProperty.Id = MovementLinkObject_GoodsProperty.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_PartnerExternal_Partner
                                 ON ObjectLink_PartnerExternal_Partner.ObjectId = Object_From.Id
                                AND ObjectLink_PartnerExternal_Partner.DescId = zc_ObjectLink_PartnerExternal_Partner()
            LEFT JOIN Object AS Object_PartnerFrom ON Object_PartnerFrom.Id = ObjectLink_PartnerExternal_Partner.ChildObjectId

       WHERE Movement.Id = inMovementId
         AND Movement.DescId = zc_Movement_SaleExternal();
     
    RETURN NEXT Cursor1;


    OPEN Cursor2 FOR
         WITH tmpMI AS (SELECT MovementItem.Id                               AS MovementItemId
                             , COALESCE (MovementItem.ObjectId, 0)           AS GoodsId
                             , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                             , MovementItem.Amount                           AS Amount
                             , MovementItem.isErased
                      FROM MovementItem 
                                  LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                   ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                  AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                     WHERE MovementItem.MovementId = inMovementId
                       AND MovementItem.DescId     = zc_MI_Master()
                       AND MovementItem.isErased   = False
                     )
   
        -- Результат такой
        SELECT
             tmpResult.MovementItemId
           , tmpResult.Amount           :: TFloat   AS Amount
           , MIString_Comment.ValueData :: TVarChar AS Comment
         
           , Object_Goods.Id                        AS GoodsId
           , Object_Goods.ObjectCode                AS GoodsCode
           , COALESCE (Object_Goods.ValueData, '')     :: TVarChar AS GoodsName

           , Object_GoodsKind.Id                    AS GoodsKindId
           , COALESCE (Object_GoodsKind.ValueData, '') :: TVarChar AS GoodsKindName

       FROM tmpMI AS tmpResult
            LEFT JOIN MovementItemString AS MIString_Comment
                                         ON MIString_Comment.MovementItemId = tmpResult.MovementItemId
                                        AND MIString_Comment.DescId = zc_MIString_Comment()

            LEFT JOIN Object AS Object_Goods     ON Object_Goods.Id     = tmpResult.GoodsId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpResult.GoodsKindId
       ;

    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 25.07.16         * 
*/

-- тест
-- SELECT * FROM gpSelect_Movement_SaleExternal_Print (inMovementId := 432692, inSession:= '5');
