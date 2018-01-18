-- Function: gpGet_MIReturnIn_Partion_byBarcode()

DROP FUNCTION IF EXISTS gpGet_MIReturnIn_Partion_byBarcode (Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MIReturnIn_Partion_byBarcode(
    IN inMovementId        Integer    ,
    IN inBarCode           TVarChar   , --
    IN inSession           TVarChar     -- сессия пользователя
)
RETURNS TABLE (GoodsId    Integer
             , PartionId  Integer
             , SaleMI_Id  Integer
             , PriceSale  TFloat
              )
AS
$BODY$
   DECLARE vbUserId    Integer;
   DECLARE vbPartionId Integer;
   DECLARE vbUnitId    Integer;
   DECLARE vbClientId  Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);


     -- нашли Партию
     vbPartionId := (SELECT tmp.PartionId FROM gpGet_MISale_Partion_byBarcode (inBarCode, inSession) AS tmp);

     
     -- данные из шапки док. возврат
     SELECT MovementLinkObject_To.ObjectId
          , MovementLinkObject_From.ObjectId
        INTO vbUnitId, vbClientId
     FROM Movement 
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
     WHERE Movement.Id = inMovementId;
     
             
     -- находим МИ продажи
     CREATE TEMP TABLE _tmpData (PartionId Integer, GoodsId Integer, MI_Id Integer, OperPriceList TFloat) ON COMMIT DROP;
      INSERT INTO _tmpData (PartionId, GoodsId, MI_Id, OperPriceList)
        WITH 
            tmpSale AS (SELECT Movement.Id          AS MovementId_Sale
                             , Movement.OperDate    AS OperDate_Sale
                        FROM Movement
                            INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                          ON MovementLinkObject_To.MovementId = Movement.Id
                                                         AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                         AND MovementLinkObject_To.ObjectId = vbClientId
                            INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                          ON MovementLinkObject_From.MovementId = Movement.Id
                                                         AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                         AND MovementLinkObject_From.ObjectId = vbUnitId
                        WHERE Movement.DescId = zc_Movement_Sale()
                      --    AND Movement.StatusId = zc_Enum_Status_Complete()
                        )

         ,  tmpMI_Sale AS (SELECT tmpSale.OperDate_Sale
                                , MI_Master.Id         AS MI_Id
                                , MI_Master.PartionId  AS PartionId
                                , MI_Master.ObjectId   AS GoodsId
                                , COALESCE (MIFloat_OperPriceList.ValueData, 0)   AS OperPriceList
                                , Row_Number() OVER (ORDER BY tmpSale.OperDate_Sale Desc)  AS Ord
                           FROM tmpSale
                                INNER JOIN MovementItem AS MI_Master 
                                                        ON MI_Master.MovementId = tmpSale.MovementId_Sale
                                                       AND MI_Master.DescId     = zc_MI_Master()
                                                       AND MI_Master.PartionId  = vbPartionId
                                                       AND MI_Master.isErased   = False
 
                                LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                                            ON MIFloat_OperPriceList.MovementItemId = MI_Master.Id
                                                           AND MIFloat_OperPriceList.DescId         = zc_MIFloat_OperPriceList()

                                LEFT JOIN MovementItemFloat AS MIFloat_TotalCountReturn
                                                            ON MIFloat_TotalCountReturn.MovementItemId = MI_Master.Id
                                                           AND MIFloat_TotalCountReturn.DescId         = zc_MIFloat_TotalCountReturn() 
                           WHERE MI_Master.Amount - COALESCE (MIFloat_TotalCountReturn.ValueData,0) > 0
                        ) 
                      
        SELECT tmpMI_Sale.PartionId
             , tmpMI_Sale.GoodsId
             , tmpMI_Sale.MI_Id
             , tmpMI_Sale.OperPriceList
        FROM  tmpMI_Sale
        WHERE tmpMI_Sale.Ord = 1;
     
     
     IF NOT EXISTS (SELECT _tmpData.PartionId FROM _tmpData)
     THEN
         RAISE EXCEPTION 'Ошибка.Товар = <%> р. = <%> в продаже Покупателю <%> не найден.', lfGet_Object_ValueData    ((SELECT Object_PartionGoods.GoodsId     FROM Object_PartionGoods WHERE Object_PartionGoods.MovementItemId = vbPartionId))
                                                                                          , lfGet_Object_ValueData_sh ((SELECT Object_PartionGoods.GoodsSizeId FROM Object_PartionGoods WHERE Object_PartionGoods.MovementItemId = vbPartionId))
                                                                                          , lfGet_Object_ValueData_sh (vbClientId)
                                                                                           ;
     END IF;
     
     
     -- Результат
     RETURN QUERY
       
       SELECT _tmpData.GoodsId            AS GoodsId
            , _tmpData.PartionId          AS PartionId
            , _tmpData.MI_Id              AS SaleMI_Id
            , _tmpData.PriceSale ::TFloat AS PriceSale
       FROM _tmpData;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 29.12.17         *
*/

-- тест
-- SELECT * FROM gpGet_MIReturnIn_Partion_byBarcode (inMovementId := 0, inBarCode:= '2010002606122'::TVarChar, inSession:= zfCalc_UserAdmin());
-- select * from gpGet_MIReturnIn_Partion_byBarcode(inMovementId := 278127 , inBarCode := '74860575060024' ::TVarChar,  inSession := '2' ::TVarChar);
