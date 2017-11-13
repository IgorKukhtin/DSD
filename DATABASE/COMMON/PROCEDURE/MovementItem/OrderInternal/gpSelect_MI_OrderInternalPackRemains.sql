-- Function: gpSelect_MI_OrderInternalPackRemains()

DROP FUNCTION IF EXISTS gpSelect_MI_OrderInternalPackRemains (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_OrderInternalPackRemains(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS SETOF REFCURSOR
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE Cursor1 refcursor;
   DECLARE Cursor2 refcursor;
   DECLARE Cursor3 refcursor;

   DECLARE vbOperDate TDateTime;
   DECLARE vbDayCount Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_MI_OrderInternal());
     vbUserId:= lpGetUserBySession (inSession);


     -- получааем  _Result_Master, _Result_Child, _Result_ChildTotal
     PERFORM lpSelect_MI_OrderInternalPackRemains (inMovementId:= inMovementId, inShowAll:= FALSE, inIsErased:= FALSE, inUserId:= vbUserId) ;

       --
       OPEN Cursor1 FOR

       -- Результат
       SELECT _Result_Master.Id        
            , _Result_Master.KeyId     
            , _Result_Master.GoodsId   
            , _Result_Master.GoodsCode 
            , _Result_Master.GoodsName 
            , _Result_Master.GoodsId_basis  
            , _Result_Master.GoodsCode_basis
            , _Result_Master.GoodsName_basis
            , _Result_Master.GoodsKindId    
            , _Result_Master.GoodsKindName  
            , _Result_Master.MeasureName    
            , _Result_Master.MeasureName_basis 
            , _Result_Master.GoodsGroupNameFull
            , _Result_Master.isCheck_basis     
            , _Result_Master.Amount            
            , _Result_Master.AmountSecond      
            , _Result_Master.AmountTotal       
            , _Result_Master.Amount_result     
            , _Result_Master.Amount_result_two 
            , _Result_Master.Num               
            , _Result_Master.Income_CEH        
            , _Result_Master.Income_PACK_to  
            , _Result_Master.Income_PACK_from
            , _Result_Master.Remains            
            , _Result_Master.Remains_pack             
            , _Result_Master.Remains_CEH              
            , _Result_Master.Remains_CEH_Next         
            , _Result_Master.AmountPartnerPrior       
            , _Result_Master.AmountPartnerPriorPromo  
            , _Result_Master.AmountPartnerPriorTotal  
            , _Result_Master.AmountPartner            
            , _Result_Master.AmountPartnerPromo       
            , _Result_Master.AmountPartnerTotal       
            , _Result_Master.AmountForecast           
            , _Result_Master.AmountForecastPromo      
            , _Result_Master.AmountForecastOrder      
            , _Result_Master.AmountForecastOrderPromo 
            , _Result_Master.CountForecast            
            , _Result_Master.CountForecastOrder       
            , _Result_Master.DayCountForecast         
            , _Result_Master.DayCountForecastOrder    
            , _Result_Master.ReceiptId                
            , _Result_Master.ReceiptCode              
            , _Result_Master.ReceiptName              
            , _Result_Master.ReceiptId_basis          
            , _Result_Master.ReceiptCode_basis        
            , _Result_Master.ReceiptName_basis        
            , _Result_Master.UnitId                   
            , _Result_Master.UnitCode                 
            , _Result_Master.UnitName                 
            , _Result_Master.isErased

       FROM _Result_Master
       ;
       RETURN NEXT Cursor1;


       OPEN Cursor2 FOR
       SELECT _Result_Child.Id
            , _Result_Child.ContainerId
            , _Result_Child.KeyId     
            , _Result_Child.GoodsId   
            , _Result_Child.GoodsCode 
            , _Result_Child.GoodsName 
            , _Result_Child.GoodsKindId    
            , _Result_Child.GoodsKindName  
            , _Result_Child.MeasureName    
            , _Result_Child.GoodsGroupNameFull
            , _Result_Child.AmountPack            
            , _Result_Child.AmountPackSecond      
            , _Result_Child.AmountPackTotal       
            , _Result_Child.AmountPack_calc       
            , _Result_Child.AmountSecondPack_calc 
            , _Result_Child.AmountPackTotal_calc  
            , _Result_Child.Amount_result_two     
            , _Result_Child.Income_PACK_to          
            , _Result_Child.Income_PACK_from        
            , _Result_Child.Remains                 
            , _Result_Child.Remains_pack            
            , _Result_Child.AmountPartnerPrior      
            , _Result_Child.AmountPartnerPriorPromo 
            , _Result_Child.AmountPartnerPriorTotal 
            , _Result_Child.AmountPartner           
            , _Result_Child.AmountPartnerPromo      
            , _Result_Child.AmountPartnerTotal      
            , _Result_Child.AmountForecast          
            , _Result_Child.AmountForecastPromo     
            , _Result_Child.AmountForecastOrder     
            , _Result_Child.AmountForecastOrderPromo
            , _Result_Child.CountForecast           
            , _Result_Child.CountForecastOrder      
            , _Result_Child.DayCountForecast        
            , _Result_Child.DayCountForecastOrder   
            , _Result_Child.DayCountForecast_calc    
            , _Result_Child.ReceiptId                
            , _Result_Child.ReceiptCode              
            , _Result_Child.ReceiptName              
            , _Result_Child.ReceiptId_basis          
            , _Result_Child.ReceiptCode_basis        
            , _Result_Child.ReceiptName_basis        
            , _Result_Child.isErased
       FROM _Result_Child 
       ;
       RETURN NEXT Cursor2;

       OPEN Cursor3 FOR
       SELECT _Result_ChildTotal.Id
            , _Result_ChildTotal.ContainerId        
            , _Result_ChildTotal.GoodsId   
            , _Result_ChildTotal.GoodsCode 
            , _Result_ChildTotal.GoodsName 
            , _Result_ChildTotal.GoodsId_complete
            , _Result_ChildTotal.GoodsCode_complete
            , _Result_ChildTotal.GoodsName_complete
            , _Result_ChildTotal.GoodsId_basis
            , _Result_ChildTotal.GoodsCode_basis
            , _Result_ChildTotal.GoodsName_basis
            , _Result_ChildTotal.GoodsKindId
            , _Result_ChildTotal.GoodsKindName
            , _Result_ChildTotal.GoodsKindId_complete
            , _Result_ChildTotal.GoodsKindName_complete
            , _Result_ChildTotal.MeasureName
            , _Result_ChildTotal.MeasureName_complete
            , _Result_ChildTotal.MeasureName_basis    
            , _Result_ChildTotal.GoodsGroupNameFull
            , _Result_ChildTotal.isCheck_basis
            , _Result_ChildTotal.Amount            
            , _Result_ChildTotal.AmountSecond      
            , _Result_ChildTotal.AmountTotal    
            , _Result_ChildTotal.AmountPack            
            , _Result_ChildTotal.AmountPackSecond      
            , _Result_ChildTotal.AmountPackTotal
            , _Result_ChildTotal.AmountPack_calc       
            , _Result_ChildTotal.AmountSecondPack_calc 
            , _Result_ChildTotal.AmountPackTotal_calc  
            , _Result_ChildTotal.Amount_result
            , _Result_ChildTotal.Amount_result_two
            , _Result_ChildTotal.Income_CEH    
            , _Result_ChildTotal.Income_PACK_to          
            , _Result_ChildTotal.Income_PACK_from 
            , _Result_ChildTotal.Remains_CEH
            , _Result_ChildTotal.Remains_CEH_Next 
            , _Result_ChildTotal.Remains_CEH_err  
            , _Result_ChildTotal.Remains                 
            , _Result_ChildTotal.Remains_pack  
            , _Result_ChildTotal.Remains_err          
            , _Result_ChildTotal.AmountPartnerPrior      
            , _Result_ChildTotal.AmountPartnerPriorPromo 
            , _Result_ChildTotal.AmountPartnerPriorTotal 
            , _Result_ChildTotal.AmountPartner           
            , _Result_ChildTotal.AmountPartnerPromo      
            , _Result_ChildTotal.AmountPartnerTotal 
            , _Result_ChildTotal.AmountForecast          
            , _Result_ChildTotal.AmountForecastPromo     
            , _Result_ChildTotal.AmountForecastOrder     
            , _Result_ChildTotal.AmountForecastOrderPromo
            , _Result_ChildTotal.CountForecast           
            , _Result_ChildTotal.CountForecastOrder      
            , _Result_ChildTotal.DayCountForecast        
            , _Result_ChildTotal.DayCountForecastOrder   
            , _Result_ChildTotal.DayCountForecast_calc    
            , _Result_ChildTotal.ReceiptId                
            , _Result_ChildTotal.ReceiptCode              
            , _Result_ChildTotal.ReceiptName              
            , _Result_ChildTotal.ReceiptId_basis          
            , _Result_ChildTotal.ReceiptCode_basis        
            , _Result_ChildTotal.ReceiptName_basis        
            , _Result_ChildTotal.UnitId                   
            , _Result_ChildTotal.UnitCode                 
            , _Result_ChildTotal.UnitName 
            , _Result_ChildTotal.GoodsKindName_pf
            , _Result_ChildTotal.GoodsKindCompleteName_pf
            , _Result_ChildTotal.PartionDate_pf
            , _Result_ChildTotal.PartionGoods_start
            , _Result_ChildTotal.TermProduction          
            , _Result_ChildTotal.isErased  

       FROM _Result_ChildTotal
       ;

       RETURN NEXT Cursor3;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MI_OrderInternalPackRemains (Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 13.11.17         *
 29.10.17         *
 19.06.15                                        * all
 31.03.15         * add GoodsGroupNameFull
 02.03.14         * add AmountRemains, AmountPartner, AmountForecast, AmountForecastOrder
 06.06.14                                                       *
*/

-- тест
-- SELECT * FROM gpSelect_MI_OrderInternalPackRemains (inMovementId:= 1828419, inShowAll:= TRUE, inIsErased:= FALSE, inSession:= '9818')
-- SELECT * FROM gpSelect_MI_OrderInternalPackRemains (inMovementId:= 1828419, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= '2') ; FETCH ALL "<unnamed portal 1>";
