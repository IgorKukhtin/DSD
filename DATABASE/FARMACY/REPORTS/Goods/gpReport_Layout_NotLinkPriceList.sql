-- Function: gpReport_Layout_NotLinkPriceList()

DROP FUNCTION IF EXISTS gpReport_Layout_NotLinkPriceList (TVarChar);


CREATE OR REPLACE FUNCTION gpReport_Layout_NotLinkPriceList(
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (GoodsId Integer
             , MorionCode Integer
             , BarCode TVarChar
             , GoodsCode Integer
             , GoodsName TVarChar
             , OperDate TDateTime
             , GoodsJuridicalCode TVarChar
             , GoodsJuridicalName TVarChar
             , JuridicalName TVarChar
             , ContractName TVarChar
             , AreaName TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbTmpDate TDateTime;
   --DECLARE vbisFarm Boolean;
   DECLARE vbUnitId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

   RETURN QUERY
   WITH
        -- Выкладка       
         tmpLayoutMovement AS (SELECT Movement.Id                                             AS Id
                                    , COALESCE(MovementBoolean_PharmacyItem.ValueData, FALSE) AS isPharmacyItem
                               FROM Movement
                                    LEFT JOIN MovementBoolean AS MovementBoolean_PharmacyItem
                                                              ON MovementBoolean_PharmacyItem.MovementId = Movement.Id
                                                             AND MovementBoolean_PharmacyItem.DescId = zc_MovementBoolean_PharmacyItem()
                               WHERE Movement.DescId = zc_Movement_Layout()
                                 AND Movement.StatusId = zc_Enum_Status_Complete()
                              )
       , tmpLayout AS (SELECT DISTINCT
                              MovementItem.ObjectId              AS GoodsId
                       FROM tmpLayoutMovement AS Movement
                            INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                   AND MovementItem.DescId = zc_MI_Master()
                                                   AND MovementItem.isErased = FALSE
                                                   AND MovementItem.Amount > 0
                      )
     SELECT tmpLayout.GoodsId
          , Object_Goods_Main.MorionCode
          , Object_Goods_BarCode.BarCode
          , Object_Goods_Main.ObjectCode        AS GoodsCode
          , Object_Goods_Main.Name              AS GoodsName
          , LoadPriceList.OperDate              AS OperDate
          , LoadPriceListItem.goodscode         AS GoodsJuridicalCode
          , LoadPriceListItem.goodsname         AS GoodsJuridicalName
          , Object_Juridical.ValueData          AS JuridicalName
          , Object_Contract.ValueData           AS ContractName
          , Object_Area.ValueData               AS AreaName
     FROM tmpLayout
     
          INNER JOIN Object_Goods_Retail ON Object_Goods_Retail.ID = tmpLayout.GoodsId
          INNER JOIN Object_Goods_Main ON Object_Goods_Main.ID = Object_Goods_Retail.GoodsMainId
          LEFT JOIN Object_Goods_BarCode ON Object_Goods_BarCode.ID = Object_Goods_Main.Id
          
          LEFT JOIN LoadPriceListItem ON (LoadPriceListItem.CommonCode = Object_Goods_Main.MorionCode or LoadPriceListItem.barcode = Object_Goods_BarCode.barcode)
                                     AND LoadPriceListItem.goodsid is Null
          LEFT JOIN Object_Goods_Juridical ON Object_Goods_Juridical.ID = LoadPriceListItem.goodsid
          
          INNER JOIN LoadPriceList ON LoadPriceList.Id = LoadPriceListItem.LoadPriceListId

          LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = LoadPriceList.JuridicalId
          LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = LoadPriceList.ContractId
          LEFT JOIN Object AS Object_Area ON Object_Area.Id = LoadPriceList.AreaId

     WHERE COALESCE(LoadPriceListItem.id, 0) <> 0 AND 
           (COALESCE (Object_Goods_Juridical.ID, 0) = 0 OR Object_Goods_Juridical.GoodsMainId <> Object_Goods_Retail.GoodsMainId)
    ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В. 
 12.01.22                                                       *
*/

-- тест
--
SELECT * FROM gpReport_Layout_NotLinkPriceList (inSession:= '3')       
 
 