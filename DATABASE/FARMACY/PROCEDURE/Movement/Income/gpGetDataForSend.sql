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
  DECLARE vbClientId Integer; 
  DECLARE vbConnectionString TVarChar;
  DECLARE vbQueryText TBlob;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Income());
 
    PERFORM lpCheckComplete_Movement_Income (inMovementId);
    vbUserId := inSession;

         SELECT 
             Object_ImportExportLink_View.IntegerKey       
           , Object_ImportExportLink_View.StringKey
           , ClientLink.IntegerKey INTO vbUnitId, vbConnectionString, vbClientId
           
       FROM Movement_Income_View    
         LEFT JOIN Object_ImportExportLink_View ON Object_ImportExportLink_View.LinkTypeId = zc_Enum_ImportExportLinkType_UnitUnitId()
                                               AND Object_ImportExportLink_View.MainId = Movement_Income_View.ToId
         LEFT JOIN Object_Unit_View AS Object_Unit_View ON Object_Unit_View.id = Movement_Income_View.ToId
         LEFT JOIN Object_ImportExportLink_View AS ClientLink ON ClientLink.LinkTypeId = zc_Enum_ImportExportLinkType_OldClientLink()
                                               AND ClientLink.MainId = Object_Unit_View.parentid
                                               AND ClientLink.ValueId = Movement_Income_View.ContractId
         
      WHERE Movement_Income_View.Id = inMovementId;
      
    IF COALESCE(vbUnitId, 0) = 0 THEN 
       RAISE EXCEPTION 'Не установлено подразделение стыковки';	
    END IF;   

    RETURN QUERY
       SELECT vbConnectionString, STRING_AGG (OneProcedure, ';')::TBlob
       FROM (SELECT 
     'call "DBA"."LoadIncomeBillItems"('''||Movement_Income_View.InvNumber||''','''||to_char(Movement_Income_View.OperDate, 'yyyy-mm-dd')||
          ''','''||to_char(Movement_Income_View.PaymentDate, 'yyyy-mm-dd')||
          ''','||0::integer||','''||coalesce(Juridical.OKPO,'')||''','||COALESCE(vbClientId, 0)||','||vbUnitId||','||ObjectFloat_NDSKind_NDS.ValueData||
          ','||MovementItem.GoodsCode||','''||MovementItem.GoodsName||''','''||Object_Goods_View.MeasureName||''','||MovementItem.Amount||','||
             MovementItem.PriceWithVAT||','||PriceSale||')'::text AS OneProcedure
       FROM Movement_Income_View    
         LEFT JOIN ObjectHistory_JuridicalDetails_View AS Juridical ON Juridical.JuridicalId = Movement_Income_View.FromId
         LEFT JOIN (SELECT GoodsId, GoodsCode, GoodsName, SUM(Amount) AS Amount, SUM(Amount*PriceWithVAT)/SUM(Amount) AS PriceWithVAT, PriceSale
                      FROM MovementItem_Income_View AS MovementItem 
                     WHERE MovementItem.MovementId = inMovementId
                       AND MovementItem.isErased = false
                     GROUP BY GoodsId, GoodsCode, GoodsName, PriceSale) AS MovementItem ON true
        LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                              ON ObjectFloat_NDSKind_NDS.ObjectId = Movement_Income_View.NDSKindId 
                             AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()   
        LEFT JOIN Object_Goods_View ON Object_Goods_View.Id = MovementItem.GoodsId                     
      WHERE Movement_Income_View.Id = inMovementId) AS DD; 

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGetDataForSend(Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 14.04.15                         *
 27.01.15                         *
 12.01.15                         *
 26.12.14                         *
 09.12.14                         *
 03.07.14                                                       *

*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_Income (inMovementId:= 25173, inShowAll:= TRUE, inIsErased:= FALSE, inSession:= '9818')
--
SELECT * FROM gpGetDataForSendNew (inMovementId:= 53675  , inSession:= '2') --15532 --15476
--call "DBA"."LoadIncomeBillItems"('БН8687','2015-01-20','2015-01-20',1,'35341093',0,79,7.0000,12654,'Тонометр Росма (...)"

