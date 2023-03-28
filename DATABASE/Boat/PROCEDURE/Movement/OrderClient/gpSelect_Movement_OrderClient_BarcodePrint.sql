-- Function: gpSelect_Movement_OrderClient_BarcodePrint ()

DROP FUNCTION IF EXISTS gpSelect_Movement_OrderClient_BarcodePrint (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_OrderClient_BarcodePrint(
    IN inSession                      TVarChar      -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE Cursor1 refcursor;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);
     

     -- Результат
     OPEN Cursor1 FOR

       -- Результат
     -- данные из документа заказа
     SELECT Movement_OrderClient.OperDate
          , Movement_OrderClient.InvNumber
          , zfCalc_InvNumber_isErased ('', Movement_OrderClient.InvNumber, Movement_OrderClient.OperDate, Movement_OrderClient.StatusId) AS InvNumber_OrderClient_full
          , zfFormat_BarCode (zc_BarCodePref_Movement(), Movement_OrderClient.Id) AS BarCode_OrderClient
          , Object_From.ValueData    AS FromName
          , Object_Product.ValueData AS ProductName
     FROM Movement AS Movement_OrderClient
          INNER JOIN MovementLinkObject AS MovementLinkObject_Product
                                        ON MovementLinkObject_Product.MovementId = Movement_OrderClient.Id
                                       AND MovementLinkObject_Product.DescId = zc_MovementLinkObject_Product()
          LEFT JOIN Object AS Object_Product  ON Object_Product.Id  = MovementLinkObject_Product.ObjectId
          
          LEFT JOIN Movement AS Movement_ProductionUnion
                             ON Movement_ProductionUnion.ParentId = Movement_OrderClient.Id
                            AND Movement_ProductionUnion.DescId   = zc_Movement_ProductionUnion()
                            AND Movement_ProductionUnion.StatusId = zc_Enum_Status_Complete()

          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement_OrderClient.Id
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

     WHERE Movement_OrderClient.DescId = zc_Movement_OrderClient()
       AND Movement_OrderClient.StatusId <> zc_Enum_Status_Erased()
       AND Movement_ProductionUnion.Id IS NULL
       ;

     RETURN NEXT Cursor1;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.02.21          *
*/

-- тест
--