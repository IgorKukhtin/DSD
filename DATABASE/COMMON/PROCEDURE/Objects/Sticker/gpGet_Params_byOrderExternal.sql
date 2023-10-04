-- Function: gpGet_Params_byOrderExternal()

DROP FUNCTION IF EXISTS gpGet_Params_byOrderExternal (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Params_byOrderExternal (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Params_byOrderExternal(
    IN inMovementId    Integer,       -- Заказ покупателя
    IN inRetailId      Integer,
    IN inSession       TVarChar       -- сессия пользователя
)
RETURNS TABLE (GoodsPropertyId Integer, GoodsPropertyName TVarChar
             , RetailId Integer, RetailName TVarChar 
             , MovementId Integer, InvNumber TVarChar
              )
AS     
$BODY$
   DECLARE vbUserId        Integer;
   DECLARE vbGoodsPropertyId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpGetUserBySession (inSession);
    
 
 --Если выбран заказ по нему опраделяем Сеть и классификатор
   IF COALESCE (inMovementId,0) <> 0
   THEN
       --сеть из документа заказа
       SELECT COALESCE (MovementLinkObject_Retail.ObjectId, ObjectLink_Juridical_Retail.ChildObjectId) AS RetailId
      INTO inRetailId
       FROM Movement
            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                 ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                                AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
            LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                 ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
          
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Retail
                                         ON MovementLinkObject_Retail.MovementId = Movement.Id
                                        AND MovementLinkObject_Retail.DescId = zc_MovementLinkObject_Retail()
       WHERE Movement.Id = inMovementId
         AND Movement.DescId = zc_Movement_OrderExternal()
        ;
   END IF;


   -- поиск
     vbGoodsPropertyId:= COALESCE ((SELECT MAX (OL_Juridical_GoodsProperty.ChildObjectId)
                                    FROM ObjectLink AS OL_Juridical_Retail
                                         INNER JOIN ObjectLink AS OL_Juridical_GoodsProperty
                                                               ON OL_Juridical_GoodsProperty.ObjectId      = OL_Juridical_Retail.ObjectId
                                                              AND OL_Juridical_GoodsProperty.DescId        = zc_ObjectLink_Juridical_GoodsProperty()
                                                              AND OL_Juridical_GoodsProperty.ChildObjectId > 0
                                    WHERE OL_Juridical_Retail.ChildObjectId = inRetailId
                                      AND OL_Juridical_Retail.DescId        = zc_ObjectLink_Juridical_Retail()
                                   )
                                 , (SELECT OL_Retail_GoodsProperty.ChildObjectId
                                    FROM ObjectLink AS OL_Retail_GoodsProperty
                                    WHERE OL_Retail_GoodsProperty.ObjectId = inRetailId
                                      AND OL_Retail_GoodsProperty.DescId   = zc_ObjectLink_Retail_GoodsProperty()
                                   )
                                 , zfCalc_GoodsPropertyId (0, zc_Juridical_Basis(), 0)
                                  );


       RETURN QUERY 
       SELECT Object_GoodsProperty.Id         AS GoodsPropertyId
            , Object_GoodsProperty.ValueData  AS GoodsPropertyName
            
            , Object_Retail.Id                AS RetailId
            , Object_Retail.ValueData         AS RetailName  
            
            , Movement.Id                     AS MovementId
            , CASE WHEN MovementString_InvNumberPartner.ValueData <> '' THEN MovementString_InvNumberPartner.ValueData ELSE '***' || Movement.InvNumber END :: TVarChar AS InvNumber

       FROM Object AS Object_GoodsProperty
             LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = inRetailId

             LEFT JOIN Movement ON Movement.Id = inMovementId

             LEFT JOIN tmpMovementString AS MovementString_InvNumberPartner
                                         ON MovementString_InvNumberPartner.MovementId = Movement.Id
                                        AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
       WHERE Object_GoodsProperty.Id = vbGoodsPropertyId
       ;

  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.10.23         *
*/

-- тест
-- SELECT * FROM gpGet_Params_byOrderExternal (26348745,  '5')
