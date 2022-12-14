-- Function: gpSelect_Object_Product_StructureHeaderPrint ()

DROP FUNCTION IF EXISTS gpSelect_Object_Product_StructureHeaderPrint (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Product_StructureHeaderPrint(
    IN inMovementId_OrderClient       Integer   ,   -- 
    IN inSession                      TVarChar      -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, ProdColorName TVarChar
             , CIN TVarChar, EngineNum TVarChar
             , Comment TVarChar
             , ProdGroupId Integer, ProdGroupName TVarChar
             , ModelName_full TVarChar
             , EngineId Integer, EngineName TVarChar
             , ReceiptProdModelId Integer, ReceiptProdModelName TVarChar
             , ClientId Integer, ClientCode Integer, ClientName TVarChar
             , MovementId_OrderClient Integer
             , OperDate_OrderClient  TDateTime
             , InvNumber_OrderClient TVarChar

             , InsertName TVarChar
             , InsertDate TDateTime

               -- Цена продажи с сайта - без НДС, Basis+options 
             , OperPrice_load TFloat
               -- Базовая цена продажи модели с сайта
             , BasisPrice_load TFloat
               -- load Сумма транспорт с сайта 
             , TransportSumm_load TFloat

             , Text_Info1 TBlob
             , Text_Info2 TBlob
             , Text_Info3 TBlob
              )
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);


      -- Результат
      RETURN QUERY
      WITH tmpProduct AS (SELECT gpSelect.Id, gpSelect.Code, gpSelect.Name, gpSelect.ProdColorName
                               , gpSelect.CIN, gpSelect.EngineNum
                               , gpSelect.Comment
                               , gpSelect.ProdGroupId, gpSelect.ProdGroupName
                               , gpSelect.ModelName_full
                               , gpSelect.EngineId, gpSelect.EngineName
                               , gpSelect.ReceiptProdModelId, gpSelect.ReceiptProdModelName
                               , gpSelect.ClientId, gpSelect.ClientCode, gpSelect.ClientName
                               , gpSelect.MovementId_OrderClient
                               , gpSelect.OperDate_OrderClient
                               , gpSelect.InvNumber_OrderClient
                               , gpSelect.InsertName, gpSelect.InsertDate
                                 -- Цена продажи с сайта - без НДС, Basis+options 
                               , gpSelect.OperPrice_load
                                 -- Базовая цена продажи модели с сайта
                               , gpSelect.BasisPrice_load
                                 -- load Сумма транспорт с сайта 
                               , gpSelect.TransportSumm_load
                          FROM gpSelect_Object_Product (inIsShowAll:= TRUE, inIsSale:= TRUE, inSession:= inSession) AS gpSelect
                          WHERE gpSelect.MovementId_OrderClient = inMovementId_OrderClient
                         )
       -- выбор Примечаний
     , tmp_OrderInfo AS (SELECT CASE WHEN TRIM (COALESCE (MovementBlob_Info1.ValueData,'')) = '' THEN CHR (13) || CHR (13) || CHR (13) ELSE MovementBlob_Info1.ValueData END :: TBlob AS Text_Info1
                              , CASE WHEN TRIM (COALESCE (MovementBlob_Info2.ValueData,'')) = '' THEN CHR (13) || CHR (13) || CHR (13) ELSE MovementBlob_Info2.ValueData END :: TBlob AS Text_Info2
                              , CASE WHEN TRIM (COALESCE (MovementBlob_Info3.ValueData,'')) = '' THEN CHR (13) || CHR (13) || CHR (13) ELSE MovementBlob_Info3.ValueData END :: TBlob AS Text_Info3
                         FROM Movement AS Movement_OrderClient 
                              LEFT JOIN MovementBlob AS MovementBlob_Info1
                                                     ON MovementBlob_Info1.MovementId = Movement_OrderClient.Id
                                                    AND MovementBlob_Info1.DescId = zc_MovementBlob_Info1()
                              LEFT JOIN MovementBlob AS MovementBlob_Info2
                                                     ON MovementBlob_Info2.MovementId = Movement_OrderClient.Id
                                                    AND MovementBlob_Info2.DescId = zc_MovementBlob_Info2()
                              LEFT JOIN MovementBlob AS MovementBlob_Info3
                                                     ON MovementBlob_Info3.MovementId = Movement_OrderClient.Id
                                                    AND MovementBlob_Info3.DescId = zc_MovementBlob_Info3()
                         WHERE Movement_OrderClient.Id     = inMovementId_OrderClient
                           AND Movement_OrderClient.DescId = zc_Movement_OrderClient()
                        )
       -- Результат
       SELECT tmpProduct.Id, tmpProduct.Code, tmpProduct.Name, tmpProduct.ProdColorName
            , tmpProduct.CIN, tmpProduct.EngineNum
            , tmpProduct.Comment
            , tmpProduct.ProdGroupId, tmpProduct.ProdGroupName
            , tmpProduct.ModelName_full
            , tmpProduct.EngineId, tmpProduct.EngineName
            , tmpProduct.ReceiptProdModelId, tmpProduct.ReceiptProdModelName
            , tmpProduct.ClientId, tmpProduct.ClientCode, tmpProduct.ClientName
            , tmpProduct.MovementId_OrderClient
            , tmpProduct.OperDate_OrderClient
            , tmpProduct.InvNumber_OrderClient
            , tmpProduct.InsertName, tmpProduct.InsertDate
              -- Цена продажи с сайта - без НДС, Basis+options 
            , tmpProduct.OperPrice_load
              -- Базовая цена продажи модели с сайта
            , tmpProduct.BasisPrice_load
              -- load Сумма транспорт с сайта 
            , tmpProduct.TransportSumm_load

            , tmp_OrderInfo.Text_Info1 :: TBlob AS Text_Info1
            , tmp_OrderInfo.Text_Info2 :: TBlob AS Text_Info2
            , tmp_OrderInfo.Text_Info3 :: TBlob AS Text_Info3

       FROM tmpProduct
            LEFT JOIN tmp_OrderInfo ON 1=1
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.05.22          *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Product_StructureHeaderPrint (inMovementId_OrderClient:= 662, inSession:= zfCalc_UserAdmin())
