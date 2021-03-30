-- Function: gpGet_Object_Product()

 DROP FUNCTION IF EXISTS gpGet_Object_Product(Integer, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Object_Product(Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Product(
    IN inId                      Integer,       -- Основные средства
    iN inMovementId_OrderClient  Integer, 
    IN inSession                 TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Hours TFloat, DiscountTax TFloat, DiscountNextTax TFloat
             , DateStart TDateTime, DateBegin TDateTime, DateSale TDateTime
             , CIN TVarChar, EngineNum TVarChar
             , Comment TVarChar
             , BrandId Integer, BrandName TVarChar
             , ModelId Integer, ModelName TVarChar, ModelName_full TVarChar
             , EngineId Integer, EngineName TVarChar
             , ReceiptProdModelId Integer, ReceiptProdModelName TVarChar
             , ClientId Integer, ClientName TVarChar
             , MovementId_OrderClient Integer
             , OperDate_OrderClient  TDateTime
             , InvNumber_OrderClient TVarChar
             , StatusCode_OrderClient Integer
             , StatusName_OrderClient TVarChar
             , TotalSummMVAT TFloat, TotalSummPVAT TFloat, TotalSumm TFloat, TotalSummVAT TFloat
             , isBasicConf Boolean, isProdColorPattern Boolean
             
             , MovementId_Invoice Integer  
             , OperDate_Invoice   TDateTime
             , InvNumber_Invoice  TVarChar 
             , StatusCode_Invoice Integer  
             , StatusName_Invoice TVarChar 
             , AmountIn_Invoice TFloat
             , AmountOut_Invoice TFloat
             , AmountIn_BankAccount TFloat
             , AmountOut_BankAccount TFloat
              ) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_Product());


   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
             CAST (0 as Integer)       AS Id
           , lfGet_ObjectCode(0, zc_Object_Product())   AS Code
           , CAST ('' as TVarChar)     AS Name

           , CAST (0 AS TFloat)        AS Hours
           , CAST (0 AS TFloat)        AS DiscountTax
           , CAST (0 AS TFloat)        AS DiscountNextTax
           , CAST (NULL AS TDateTime)  AS DateStart
           , CAST (NULL AS TDateTime)  AS DateBegin
           , CAST (NULL AS TDateTime)  AS DateSale
           , CAST ('' AS TVarChar)     AS CIN
           , CAST ('' AS TVarChar)     AS EngineNum
           , CAST ('' AS TVarChar)     AS Comment

          -- , CAST (0 AS Integer)    AS ProdGroupId
          -- , CAST ('' AS TVarChar)  AS ProdGroupName
           , CAST (0 AS Integer)       AS BrandId
           , CAST ('' AS TVarChar)     AS BrandName
           , CAST (0 AS Integer)       AS ModelId
           , CAST ('' AS TVarChar)     AS ModelName
           , CAST ('' AS TVarChar)     AS ModelName_full
           , CAST (0 AS Integer)       AS EngineId
           , CAST ('' AS TVarChar)     AS EngineName
           , CAST (0 AS Integer)       AS ReceiptProdModelId
           , CAST ('' AS TVarChar)     AS ReceiptProdModelName
           , CAST (0 AS Integer)       AS ClientId
           , CAST ('' AS TVarChar)     AS ClientId

           , CAST (0 AS Integer)       AS MovementId_OrderClient
           , CAST (CURRENT_DATE AS TDateTime)  AS OperDate_OrderClient
           , CAST (NEXTVAL ('movement_OrderClient_seq') AS TVarChar) AS InvNumber_OrderClient
           , Object_Status.Code        AS StatusCode_OrderClient
           , Object_Status.Name        AS StatusName_OrderClient

           , CAST (0 AS TFloat)        AS TotalSummMVAT
           , CAST (0 AS TFloat)        AS TotalSummPVAT
           , CAST (0 AS TFloat)        AS TotalSumm
           , CAST (0 AS TFloat)        AS TotalSummVAT

           , CAST (TRUE AS Boolean)    AS isBasicConf
           , CAST (TRUE AS Boolean)    AS isProdColorPattern

           , CAST (0 AS Integer)       AS MovementId_Invoice
           , CAST (NULL AS TDateTime)  AS OperDate_Invoice
           , CAST ('' AS TVarChar)     AS InvNumber_Invoice
           , Object_Status.Code        AS StatusCode_Invoice
           , Object_Status.Name        AS StatusName_Invoice
           , CAST (0 AS TFloat)        AS AmountIn_Invoice
           , CAST (0 AS TFloat)        AS AmountOut_Invoice
           , CAST (0 AS TFloat)        AS AmountIn_BankAccount
           , CAST (0 AS TFloat)        AS AmountOut_BankAccount
       FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status
       ;
   ELSE
     RETURN QUERY
     WITH
     tmpOrderClient AS (SELECT Object_From.Id             AS ClientId
                             , Object_From.ValueData      AS ClientName
                             , Object_Status.ObjectCode   AS StatusCode
                             , Object_Status.ValueData    AS StatusName
                             , Movement.InvNumber ::TVarChar
                             , Movement.OperDate  ::TDateTime
                             , Movement.Id                AS MovementId
                             , MovementFloat_DiscountTax.ValueData        AS DiscountTax
                             , MovementFloat_DiscountNextTax.ValueData    AS DiscountNextTax
                        FROM Movement
                             LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
                     
                             LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                          ON MovementLinkObject_From.MovementId = Movement.Id
                                                         AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                             LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

                             LEFT JOIN MovementFloat AS MovementFloat_DiscountTax
                                                     ON MovementFloat_DiscountTax.MovementId = Movement.Id
                                                    AND MovementFloat_DiscountTax.DescId = zc_MovementFloat_DiscountTax()

                             LEFT JOIN MovementFloat AS MovementFloat_DiscountNextTax
                                                     ON MovementFloat_DiscountNextTax.MovementId = Movement.Id
                                                    AND MovementFloat_DiscountNextTax.DescId = zc_MovementFloat_DiscountNextTax()
                        WHERE Movement.Id = inMovementId_OrderClient
                          AND Movement.DescId = zc_Movement_OrderClient()
                          )
   -- данные из док счет
   , tmpInvoice AS (SELECT  MovementLinkMovement_Invoice.MovementId AS MovementId_OrderClient
                          , Movement.Id                   AS MovementId_Invoice
                          , Movement.OperDate             AS OperDate_Invoice
                          , Movement.InvNumber ::TVarChar AS InvNumber_Invoice
                          , Object_Status.ObjectCode      AS StatusCode_Invoice
                          , Object_Status.ValueData       AS StatusName_Invoice

                            -- с НДС
                          , CASE WHEN MovementFloat_Amount.ValueData > 0 THEN  1 * MovementFloat_Amount.ValueData ELSE 0 END::TFloat AS AmountIn
                          , CASE WHEN MovementFloat_Amount.ValueData < 0 THEN -1 * MovementFloat_Amount.ValueData ELSE 0 END::TFloat AS AmountOut

                    FROM MovementLinkMovement AS MovementLinkMovement_Invoice
                         INNER JOIN Movement ON Movement.Id = MovementLinkMovement_Invoice.MovementChildId
                                            AND Movement.DescId = zc_Movement_Invoice()
                                            AND Movement.StatusId <> zc_Enum_Status_Erased()
                         LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

                         LEFT JOIN MovementFloat AS MovementFloat_Amount
                                                    ON MovementFloat_Amount.MovementId = Movement.Id
                                                   AND MovementFloat_Amount.DescId = zc_MovementFloat_Amount()

                    WHERE MovementLinkMovement_Invoice.MovementId IN (SELECT DISTINCT tmpOrderClient.MovementId FROM tmpOrderClient)
                      AND MovementLinkMovement_Invoice.DescId = zc_MovementLinkMovement_Invoice()
                    )
     -- данные по оплате счета
     , tmpBankAccount AS (SELECT MovementLinkMovement.MovementChildId AS MovementId_Invoice
                               , SUM (CASE WHEN MovementItem.Amount > 0 THEN MovementItem.Amount      ELSE 0 END) ::TFloat AS AmountIn
                               , SUM (CASE WHEN MovementItem.Amount < 0 THEN -1 * MovementItem.Amount ELSE 0 END) ::TFloat AS AmountOut
                          FROM MovementLinkMovement
                              INNER JOIN Movement AS Movement_BankAccount
                                                  ON Movement_BankAccount.Id = MovementLinkMovement.MovementId
                                                 AND Movement_BankAccount.StatusId = zc_Enum_Status_Complete()   ---<> zc_Enum_Status_Erased()
                                                 AND Movement_BankAccount.DescId = zc_Movement_BankAccount()
                              INNER JOIN MovementItem ON MovementItem.MovementId = Movement_BankAccount.Id
                                                     AND MovementItem.DescId = zc_MI_Master()
                                                     AND MovementItem.isErased = FALSE
                                                     AND COALESCE (MovementItem.Amount,0) <> 0
                          WHERE MovementLinkMovement.MovementChildId IN (SELECT DISTINCT tmpInvoice.MovementId_Invoice FROM tmpInvoice)
                            AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Invoice()
                          GROUP BY MovementLinkMovement.MovementChildId
                          )


     SELECT
           Object_Product.Id             AS Id
         , Object_Product.ObjectCode     AS Code
         , Object_Product.ValueData      AS Name

         , ObjectFloat_Hours.ValueData      AS Hours
         , tmpOrderClient.DiscountTax       AS DiscountTax
         , tmpOrderClient.DiscountNextTax   AS DiscountNextTax
         , ObjectDate_DateStart.ValueData   AS DateStart
         , ObjectDate_DateBegin.ValueData   AS DateBegin
         , ObjectDate_DateSale.ValueData    AS DateSale
         , ObjectString_CIN.ValueData       AS CIN
         , ObjectString_EngineNum.ValueData AS EngineNum
         , ObjectString_Comment.ValueData   AS Comment

         , Object_Brand.Id                  AS BrandId
         , Object_Brand.ValueData           AS BrandName

         , Object_Model.Id                  AS ModelId
         , Object_Model.ValueData           AS ModelName
         , (Object_Model.ValueData ||' (' || Object_Brand_Model.ValueData||')') ::TVarChar AS ModelName_full

         , Object_Engine.Id                 AS EngineId
         , Object_Engine.ValueData          AS EngineName

         , Object_ReceiptProdModel.Id        AS ReceiptProdModelId
         , Object_ReceiptProdModel.ValueData AS ReceiptProdModelName

         , tmpOrderClient.ClientId                 AS ClientId
         , tmpOrderClient.ClientName               AS ClientName

         , tmpOrderClient.MovementId :: Integer    AS MovementId_OrderClient
         , tmpOrderClient.OperDate   :: TDateTime  AS OperDate_OrderClient
         , tmpOrderClient.InvNumber  :: TVarChar   AS InvNumber_OrderClient
         , tmpOrderClient.StatusCode :: Integer    AS StatusCode_OrderClient
         , tmpOrderClient.StatusName :: TVarChar   AS StatusName_OrderClient

         , MovementFloat_TotalSummMVAT.ValueData      AS TotalSummMVAT
         , MovementFloat_TotalSummPVAT.ValueData      AS TotalSummPVAT
         , MovementFloat_TotalSumm.ValueData          AS TotalSumm
         , (COALESCE (MovementFloat_TotalSummPVAT.ValueData,0) - COALESCE (MovementFloat_TotalSummMVAT.ValueData,0)) :: TFloat AS TotalSummVAT

         , COALESCE (ObjectBoolean_BasicConf.ValueData, FALSE) :: Boolean AS isBasicConf
         , CAST (FALSE AS Boolean)          AS isProdColorPattern

         , tmpInvoice.MovementId_Invoice :: Integer    AS MovementId_Invoice
         , tmpInvoice.OperDate_Invoice   :: TDateTime  AS OperDate_Invoice
         , tmpInvoice.InvNumber_Invoice  :: TVarChar   AS InvNumber_Invoice
         , tmpInvoice.StatusCode_Invoice :: Integer    AS StatusCode_Invoice
         , tmpInvoice.StatusName_Invoice :: TVarChar   AS StatusName_Invoice

         , tmpInvoice.AmountIn   ::TFloat AS AmountIn_Invoice
         , tmpInvoice.AmountOut  ::TFloat AS AmountOut_Invoice
         
         , tmpBankAccount.AmountIn   ::TFloat AS AmountIn_BankAccount
         , tmpBankAccount.AmountOut  ::TFloat AS AmountOut_BankAccount
         
         
     FROM Object AS Object_Product
          LEFT JOIN ObjectBoolean AS ObjectBoolean_BasicConf
                                  ON ObjectBoolean_BasicConf.ObjectId = Object_Product.Id
                                 AND ObjectBoolean_BasicConf.DescId   = zc_ObjectBoolean_Product_BasicConf()

          LEFT JOIN ObjectFloat AS ObjectFloat_Hours
                                ON ObjectFloat_Hours.ObjectId = Object_Product.Id
                               AND ObjectFloat_Hours.DescId = zc_ObjectFloat_Product_Hours()

          LEFT JOIN ObjectFloat AS ObjectFloat_DiscountTax
                                ON ObjectFloat_DiscountTax.ObjectId = Object_Product.Id
                               AND ObjectFloat_DiscountTax.DescId = zc_ObjectFloat_Product_DiscountTax()
          LEFT JOIN ObjectFloat AS ObjectFloat_DiscountNextTax
                                ON ObjectFloat_DiscountNextTax.ObjectId = Object_Product.Id
                               AND ObjectFloat_DiscountNextTax.DescId = zc_ObjectFloat_Product_DiscountNextTax()

          LEFT JOIN ObjectDate AS ObjectDate_DateStart
                               ON ObjectDate_DateStart.ObjectId = Object_Product.Id
                              AND ObjectDate_DateStart.DescId = zc_ObjectDate_Product_DateStart()

          LEFT JOIN ObjectDate AS ObjectDate_DateBegin
                               ON ObjectDate_DateBegin.ObjectId = Object_Product.Id
                              AND ObjectDate_DateBegin.DescId = zc_ObjectDate_Product_DateBegin()

          LEFT JOIN ObjectDate AS ObjectDate_DateSale
                               ON ObjectDate_DateSale.ObjectId = Object_Product.Id
                              AND ObjectDate_DateSale.DescId = zc_ObjectDate_Product_DateSale()

          LEFT JOIN ObjectString AS ObjectString_CIN
                                 ON ObjectString_CIN.ObjectId = Object_Product.Id
                                AND ObjectString_CIN.DescId = zc_ObjectString_Product_CIN()

          LEFT JOIN ObjectString AS ObjectString_EngineNum
                                 ON ObjectString_EngineNum.ObjectId = Object_Product.Id
                                AND ObjectString_EngineNum.DescId = zc_ObjectString_Product_EngineNum()

          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_Product.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_Product_Comment()

          /*LEFT JOIN ObjectLink AS ObjectLink_ProdGroup
                               ON ObjectLink_ProdGroup.ObjectId = Object_Product.Id
                              AND ObjectLink_ProdGroup.DescId = zc_ObjectLink_Product_ProdGroup()
          LEFT JOIN Object AS Object_ProdGroup ON Object_ProdGroup.Id = ObjectLink_ProdGroup.ChildObjectId
          */

          LEFT JOIN ObjectLink AS ObjectLink_ReceiptProdModel
                               ON ObjectLink_ReceiptProdModel.ObjectId = Object_Product.Id
                              AND ObjectLink_ReceiptProdModel.DescId = zc_ObjectLink_Product_ReceiptProdModel()
          LEFT JOIN Object AS Object_ReceiptProdModel ON Object_ReceiptProdModel.Id = ObjectLink_ReceiptProdModel.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Brand
                               ON ObjectLink_Brand.ObjectId = Object_Product.Id
                              AND ObjectLink_Brand.DescId = zc_ObjectLink_Product_Brand()
          LEFT JOIN Object AS Object_Brand ON Object_Brand.Id = ObjectLink_Brand.ChildObjectId

          /*LEFT JOIN ObjectLink AS ObjectLink_Client
                               ON ObjectLink_Client.ObjectId = Object_Product.Id
                              AND ObjectLink_Client.DescId = zc_ObjectLink_Product_Client()
          LEFT JOIN Object AS Object_Client ON Object_Client.Id = ObjectLink_Client.ChildObjectId*/

          LEFT JOIN ObjectLink AS ObjectLink_Model
                               ON ObjectLink_Model.ObjectId = Object_Product.Id
                              AND ObjectLink_Model.DescId = zc_ObjectLink_Product_Model()
          LEFT JOIN Object AS Object_Model ON Object_Model.Id = ObjectLink_Model.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_ProdModel_Brand
                               ON ObjectLink_ProdModel_Brand.ObjectId = Object_Model.Id
                              AND ObjectLink_ProdModel_Brand.DescId = zc_ObjectLink_ProdModel_Brand()
          LEFT JOIN Object AS Object_Brand_Model ON Object_Brand_Model.Id = ObjectLink_ProdModel_Brand.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Engine
                               ON ObjectLink_Engine.ObjectId = Object_Product.Id
                              AND ObjectLink_Engine.DescId = zc_ObjectLink_Product_Engine()
          LEFT JOIN Object AS Object_Engine ON Object_Engine.Id = ObjectLink_Engine.ChildObjectId

          LEFT JOIN tmpOrderClient ON 1=1

          LEFT JOIN MovementFloat AS MovementFloat_TotalSummMVAT
                                  ON MovementFloat_TotalSummMVAT.MovementId = tmpOrderClient.MovementId
                                 AND MovementFloat_TotalSummMVAT.DescId = zc_MovementFloat_TotalSummMVAT()
          LEFT JOIN MovementFloat AS MovementFloat_TotalSummPVAT
                                  ON MovementFloat_TotalSummPVAT.MovementId = tmpOrderClient.MovementId
                                 AND MovementFloat_TotalSummPVAT.DescId = zc_MovementFloat_TotalSummPVAT()
          LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                  ON MovementFloat_TotalSumm.MovementId = tmpOrderClient.MovementId
                                 AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

          LEFT JOIN tmpInvoice ON tmpInvoice.MovementId_OrderClient = tmpOrderClient.MovementId
          LEFT JOIN tmpBankAccount ON tmpBankAccount.MovementId_Invoice = tmpInvoice.MovementId_Invoice
       WHERE Object_Product.Id = inId;
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.01.21         *
 08.10.20         *
*/

-- тест
-- SELECT * FROM gpGet_Object_Product(0, 0,'2')
