-- Function: gpSelect_MovementItem_Income()

DROP FUNCTION IF EXISTS gpGetDataForSend (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGetDataForSend(
    IN inMovementId  Integer      , -- ключ Документа
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (ConnectionString TVarChar, QueryText TBlob)
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbUnitId Integer;
  DECLARE vbConnectionString TVarChar;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Income());
     vbUserId := inSession;

         SELECT 
             Object_ImportExportLink_View.IntegerKey       
           , Object_ImportExportLink_View.StringKey  INTO vbUnitId, vbConnectionString
           
       FROM Movement_Income_View    
         LEFT JOIN Object_ImportExportLink_View ON Object_ImportExportLink_View.LinkTypeId = zc_Enum_ImportExportLinkType_UnitUnitId()
                                               AND Object_ImportExportLink_View.MainId = Movement_Income_View.ToId
      WHERE Movement_Income_View.Id = 804;


/*     RETURN QUERY
         SELECT 
             Movement_Income_View.InvNumber
           , Movement_Income_View.OperDate
           , Movement_Income_View.PriceWithVAT
           , Juridical.OKPO      -- OKPO
           , vbUnitId     
           , ObjectFloat_NDSKind_NDS.ValueData 
           , MovementItem.GoodsCode
           , MovementItem.Amount
           , MovementItem.Price
           , MovementItem.AmountSumm
           , Movement_Income_View.Id

       FROM Movement_Income_View    
         LEFT JOIN ObjectHistory_JuridicalDetails_View AS Juridical ON Juridical.JuridicalId = Movement_Income_View.FromId
         LEFT JOIN MovementItem_Income_View AS MovementItem ON MovementItem.MovementId = Movement_Income_View.Id
               AND MovementItem.isErased = false
        LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                              ON ObjectFloat_NDSKind_NDS.ObjectId = Movement_Income_View.NDSKindId 
                             AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()   
      WHERE Movement_Income_View.Id = inMovementId; */

      ;
      SELECT vbConnectionString, 'SELECT * FROM Goods'::TBlob;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_Income (Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 09.12.14                         *
 03.07.14                                                       *

*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_Income (inMovementId:= 25173, inShowAll:= TRUE, inIsErased:= FALSE, inSession:= '9818')
-- SELECT * FROM gpSelect_MovementItem_Income (inMovementId:= 25173, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= '2')
