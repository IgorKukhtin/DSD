-- Function: gpGet_Object_Product_FileName()

DROP FUNCTION IF EXISTS gpGet_Object_Product_FileName (Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpGet_Object_Product_FileName (
    IN inProductId          Integer  , -- ключ объекта
    IN inParam              Integer  , -- печ. которую нужно сохранить
                                        --  1 - PrintProduct_OrderConfirmation
                                        --  2 - PrintProduct_OrderConfirmation_Discount
    IN inSession            TVarChar   -- сессия пользователя
)
RETURNS TABLE (PDF_FileName TVarChar)
AS
$BODY$
     DECLARE vbPDF_FileName TVarChar;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Invoice());


     -- Названия файла - для сохранения PDF
     IF inParam = 1
     THEN
         vbPDF_FileName := 'Confirmation_' || (SELECT Movement.InvNumber
                                               FROM MovementLinkObject AS MovementLinkObject_Product
                                                    INNER JOIN Movement ON Movement.Id = MovementLinkObject_Product.MovementId
                                                                       AND Movement.DescId = zc_Movement_OrderClient()
                                                                       AND Movement.StatusId <> zc_Enum_Status_Erased()
                                               WHERE MovementLinkObject_Product.ObjectId = inProductId
                                                 AND MovementLinkObject_Product.DescId   = zc_MovementLinkObject_Product()
                                         --|| (SELECT Object.ValueData FROM Object WHERE Object.Id = inProductId)
                                              )
                                             ;
     END IF;

     IF inParam = 2
     THEN
         vbPDF_FileName := 'Confirmation_Discount_'
                                           || (SELECT Movement.InvNumber
                                               FROM MovementLinkObject AS MovementLinkObject_Product
                                                    INNER JOIN Movement ON Movement.Id = MovementLinkObject_Product.MovementId
                                                                       AND Movement.DescId = zc_Movement_OrderClient()
                                                                       AND Movement.StatusId <> zc_Enum_Status_Erased()
                                               WHERE MovementLinkObject_Product.ObjectId = inProductId
                                                 AND MovementLinkObject_Product.DescId   = zc_MovementLinkObject_Product()
                                         --|| (SELECT Object.ValueData FROM Object WHERE Object.Id = inProductId)
                                              )
                                             ;
     END IF;


     -- Результат
     RETURN QUERY
        SELECT vbPDF_FileName  -- Названия файла - для сохранения PDF
        ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.10.24         *
*/

-- тест
-- SELECT * FROM gpGet_Object_Product_FileName(inProductId := 254856 , inParam := 1 ,  inSession := '5');
