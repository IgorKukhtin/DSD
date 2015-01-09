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
  DECLARE vbQueryText TBlob;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Income());
 
    PERFORM lpCheckComplete_Movement_Income (inMovementId);
    vbUserId := inSession;

         SELECT 
             Object_ImportExportLink_View.IntegerKey       
           , Object_ImportExportLink_View.StringKey  INTO vbUnitId, vbConnectionString
           
       FROM Movement_Income_View    
         LEFT JOIN Object_ImportExportLink_View ON Object_ImportExportLink_View.LinkTypeId = zc_Enum_ImportExportLinkType_UnitUnitId()
                                               AND Object_ImportExportLink_View.MainId = Movement_Income_View.ToId
      WHERE Movement_Income_View.Id = inMovementId;
      
    IF COALESCE(vbUnitId, 0) = 0 THEN 
       RAISE EXCEPTION 'Не установлено подразделение стыковки';	
    END IF;   

    RETURN QUERY
       SELECT vbConnectionString, STRING_AGG (OneProcedure, ';')::TBlob
       FROM (SELECT 
     'call "DBA"."LoadIncomeBillItems"('''||Movement_Income_View.InvNumber||''','''||to_char(Movement_Income_View.OperDate, 'yyyy-mm-dd')||
          ''','''||to_char(Movement_Income_View.PaymentDate, 'yyyy-mm-dd')||
          ''','||Movement_Income_View.PriceWithVAT::integer||','''||coalesce(Juridical.OKPO,'')||''','||vbUnitId||','||ObjectFloat_NDSKind_NDS.ValueData||
          ','||MovementItem.GoodsCode||','''||MovementItem.GoodsName||''','||MovementItem.Amount||','||MovementItem.Price||')'::text AS OneProcedure
       FROM Movement_Income_View    
         LEFT JOIN ObjectHistory_JuridicalDetails_View AS Juridical ON Juridical.JuridicalId = Movement_Income_View.FromId
         LEFT JOIN MovementItem_Income_View AS MovementItem ON MovementItem.MovementId = Movement_Income_View.Id
               AND MovementItem.isErased = false
        LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                              ON ObjectFloat_NDSKind_NDS.ObjectId = Movement_Income_View.NDSKindId 
                             AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()   
      WHERE Movement_Income_View.Id = inMovementId) AS DD; 

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGetDataForSend (Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 26.12.14                         *
 09.12.14                         *
 03.07.14                                                       *

*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_Income (inMovementId:= 25173, inShowAll:= TRUE, inIsErased:= FALSE, inSession:= '9818')
--SELECT * FROM gpGetDataForSend (inMovementId:= 7904 , inSession:= '2')

