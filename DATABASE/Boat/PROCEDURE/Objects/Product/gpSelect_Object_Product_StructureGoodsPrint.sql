-- Function: gpSelect_Object_Product_StructureGoodsPrint ()

DROP FUNCTION IF EXISTS gpSelect_Object_Product_StructureGoodsPrint (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Product_StructureGoodsPrint(
    IN inMovementId_OrderClient       Integer   ,   -- 
    IN inSession                      TVarChar      -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;

    DECLARE vbProductId    Integer;
    DECLARE vbOperDate_OrderClient   TDateTime;
    DECLARE vbInvNumber_OrderClient  TVarChar;
    DECLARE vbInsertName TVarChar;
    DECLARE vbPriceWithVAT Boolean;
    DECLARE vbVATPercent   TFloat;
    DECLARE vbDiscountTax  TFloat;
    DECLARE vbReceiptProdModelId Integer;  
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     SELECT MovementBoolean_PriceWithVAT.ValueData  AS PriceWithVAT
          , MovementFloat_VATPercent.ValueData      AS VATPercent
          , MovementFloat_DiscountTax.ValueData     AS DiscountTax
          , Movement_OrderClient.OperDate
          , Movement_OrderClient.InvNumber
          , Object_Member.ValueData  AS InsertName 
          , ObjectLink_Product_ReceiptProdModel.ChildObjectId AS ReceiptProdModelId
     INTO
         vbPriceWithVAT
       , vbVATPercent
       , vbDiscountTax
       , vbOperDate_OrderClient
       , vbInvNumber_OrderClient
       , vbInsertName 
       , vbReceiptProdModelId
     FROM Movement AS Movement_OrderClient
         LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                   ON MovementBoolean_PriceWithVAT.MovementId = Movement_OrderClient.Id
                                  AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
         LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                 ON MovementFloat_VATPercent.MovementId = Movement_OrderClient.Id
                                AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
         LEFT JOIN MovementFloat AS MovementFloat_DiscountTax
                                 ON MovementFloat_DiscountTax.MovementId = Movement_OrderClient.Id
                                AND MovementFloat_DiscountTax.DescId = zc_MovementFloat_DiscountTax()
         LEFT JOIN MovementLinkObject AS MLO_Insert
                                      ON MLO_Insert.MovementId = Movement_OrderClient.Id
                                     AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
         --LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId

         LEFT JOIN ObjectLink AS ObjectLink_User_Member
                              ON ObjectLink_User_Member.ObjectId = MLO_Insert.ObjectId
                             AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
         LEFT JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_User_Member.ChildObjectId 

         LEFT JOIN MovementLinkObject AS MovementLinkObject_Product
                                      ON MovementLinkObject_Product.MovementId = Movement_OrderClient.Id
                                     AND MovementLinkObject_Product.DescId = zc_MovementLinkObject_Product()
         LEFT JOIN ObjectLink AS ObjectLink_Product_ReceiptProdModel
                              ON ObjectLink_Product_ReceiptProdModel.ObjectId = MovementLinkObject_Product.ObjectId
                             AND ObjectLink_Product_ReceiptProdModel.DescId = zc_ObjectLink_Product_ReceiptProdModel()

     WHERE Movement_OrderClient.Id = inMovementId_OrderClient  -- по идее должен быть один док. заказа, но малоли
       AND Movement_OrderClient.DescId = zc_Movement_OrderClient();

     -- данные из документа заказа
     CREATE TEMP TABLE tmpOrderClient ON COMMIT DROP AS (SELECT MovementItem.ObjectId       AS GoodsId
                                                              , Object_Goods.DescId         AS GoodsDesc
                                                              , Object_Goods.ValueData      AS GoodsName
                                                              , MovementItem.Amount         AS Amount
                                                              , MIFloat_OperPrice.ValueData AS OperPrice
                                                              , CASE WHEN vbPriceWithVAT THEN MIFloat_OperPrice.ValueData
                                                                                         ELSE (MIFloat_OperPrice.ValueData * (1 + vbVATPercent/100))::TFloat
                                                                END AS OperPriceWithVAT
                                                         FROM MovementItem
                                                              LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
                                                              LEFT JOIN MovementItemFloat AS MIFloat_OperPrice
                                                                                          ON MIFloat_OperPrice.MovementItemId = MovementItem.Id
                                                                                         AND MIFloat_OperPrice.DescId = zc_MIFloat_OperPrice()
                                                         WHERE MovementItem.MovementId = inMovementId_OrderClient
                                                           AND MovementItem.DescId     = zc_MI_Master()
                                                           AND MovementItem.isErased   = FALSE
                                                         );

     --ищем лодку в строчной части документа, если присутствует, значит продаем лодку, соотв. нужно показать все опции по ней
     SELECT tmpOrderClient.GoodsId
    INTO vbProductId
     FROM tmpOrderClient
     WHERE tmpOrderClient.GoodsDesc = zc_Object_Product()
     LIMIT 1;
     
 
     CREATE TEMP TABLE tmpProduct ON COMMIT DROP AS (SELECT tmp.*
                                                     FROM gpSelect_Object_Product (inIsShowAll:= TRUE, inIsSale:= FALSE, inSession:= inSession) AS tmp
                                                     WHERE tmp.Id = vbProductId
                                                       AND tmp.MovementId_OrderClient = inMovementId_OrderClient
                                                     );
     CREATE TEMP TABLE tmpProdColorItems ON COMMIT DROP AS (SELECT tmp.*
                                                            FROM gpSelect_Object_ProdColorItems (inMovementId_OrderClient:= inMovementId_OrderClient, inIsShowAll:= TRUE, inIsErased:= FALSE, inIsSale:= FALSE, inSession:= inSession) AS tmp
                                                            WHERE tmp.ProductId = vbProductId
                                                              AND tmp.MovementId_OrderClient = inMovementId_OrderClient
                                                            );

     -- выбор Примечаний
     CREATE TEMP TABLE tmp_OrderInfo ON COMMIT DROP AS (SELECT CASE WHEN TRIM (COALESCE (MovementBlob_Info1.ValueData,'')) = '' THEN CHR (13) || CHR (13) || CHR (13) ELSE MovementBlob_Info1.ValueData END :: TBlob AS Text_Info1
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
                                                        WHERE Movement_OrderClient.Id = inMovementId_OrderClient
                                                          AND Movement_OrderClient.DescId = zc_Movement_OrderClient()
                                                     );


     -- Результат
     OPEN Cursor1 FOR

       -- Результат
       SELECT tmpProduct.*
            , LEFT (tmpProduct.CIN, 8) ::TVarChar AS PatternCIN
            , EXTRACT (YEAR FROM tmpProduct.DateBegin)  ::TVarChar AS YearBegin
            , '' ::TVarChar AS ModelGroupName
            , ObjectFloat_Power.ValueData               ::TFloat   AS EnginePower
            , ObjectFloat_Volume.ValueData              ::TFloat   AS EngineVolume
            --
            , tmpInfo.Mail           ::TVarChar AS Mail
            , tmpInfo.WWW            ::TVarChar AS WWW
            , tmpInfo.Name_main      ::TVarChar AS Name_main
            , tmpInfo.Street_main    ::TVarChar AS Street_main
            , tmpInfo.City_main      ::TVarChar AS City_main                                   --*
                                  --*
            , tmpInfo.Name_Firma2    ::TVarChar AS Name_Firma
            , tmpInfo.Street_Firma2  ::TVarChar AS Street_Firma
            , tmpInfo.City_Firma2    ::TVarChar AS City_Firma
            , tmpInfo.Country_Firma2 ::TVarChar AS Country_Firma
            , tmpInfo.Text_tax       ::TVarChar AS Text1   --**
            , tmpInfo.Text_discount  ::TVarChar AS Text2
            , (tmpInfo.Text_sign||' '||vbInsertName) ::TVarChar AS Text3

            , COALESCE (ObjectString_TaxNumber.ValueData,'') ::TVarChar AS TaxNumber
            
            , tmpInfo.Footer1        ::TVarChar AS Footer1              --*
            , tmpInfo.Footer2        ::TVarChar AS Footer2
            , tmpInfo.Footer3        ::TVarChar AS Footer3              --***
            , tmpInfo.Footer4        ::TVarChar AS Footer4

            , tmp_OrderInfo.Text_Info1 :: TBlob AS Text_Info1
            , tmp_OrderInfo.Text_Info2 :: TBlob AS Text_Info2
            , tmp_OrderInfo.Text_Info3 :: TBlob AS Text_Info3

       FROM tmpProduct
          LEFT JOIN ObjectFloat AS ObjectFloat_Power
                                ON ObjectFloat_Power.ObjectId = tmpProduct.EngineId
                               AND ObjectFloat_Power.DescId = zc_ObjectFloat_ProdEngine_Power()
          LEFT JOIN ObjectFloat AS ObjectFloat_Volume
                                ON ObjectFloat_Volume.ObjectId = tmpProduct.EngineId
                               AND ObjectFloat_Volume.DescId = zc_ObjectFloat_ProdEngine_Volume()
          LEFT JOIN ObjectString AS ObjectString_TaxNumber
                                 ON ObjectString_TaxNumber.ObjectId = tmpProduct.ClientId
                                AND ObjectString_TaxNumber.DescId = zc_ObjectString_Client_TaxNumber()
          LEFT JOIN Object_Product_PrintInfo_View AS tmpInfo ON 1=1
          LEFT JOIN tmp_OrderInfo ON 1=1
       ;

     RETURN NEXT Cursor1;

     OPEN Cursor2 FOR  
     /*
     1)кол-во шаблон 2) колво резерв 3) кол-во заказ - без цен и сумм
     */
      WITH
      tmpItem AS (SELECT MovementItem.Id                           AS MovementItemId
                       , COALESCE (MovementItem.ParentId, 0)       AS ParentId
                       , MovementItem.PartionId                    AS PartionId
                       , MILinkObject_Unit.ObjectId                AS UnitId
                       , MILinkObject_Partner.ObjectId             AS PartnerId
          
                       , COALESCE (MILinkObject_Goods.ObjectId, 0) AS GoodsId
                       , MovementItem.ObjectId                     AS ObjectId
                       , MILinkObject_ProdOptions.ObjectId         AS ProdOptionsId
                       , MILinkObject_ColorPattern.ObjectId        AS ColorPatternId
                       , MILinkObject_ProdColorPattern.ObjectId    AS ProdColorPatternId
          
                       , MovementItem.Amount                       AS Amount
                       , MIFloat_AmountBasis.ValueData             AS AmountBasis
                       , MIFloat_AmountPartner.ValueData           AS AmountPartner
          
                  FROM MovementItem
                         -- !!! временно для отладки
                       LEFT JOIN MovementString AS MS ON MS.MovementId = inMovementId_OrderClient AND MS.DescId = zc_MovementString_Comment()
          
                       LEFT JOIN MovementItemLinkObject AS MILinkObject_Partner
                                                        ON MILinkObject_Partner.MovementItemId = MovementItem.Id
                                                       AND MILinkObject_Partner.DescId         = zc_MILinkObject_Partner()
                       LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                        ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                       AND MILinkObject_Unit.DescId         = zc_MILinkObject_Unit()
                       LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                                        ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                                       AND MILinkObject_Goods.DescId         = zc_MILinkObject_Goods()
                       LEFT JOIN MovementItemLinkObject AS MILinkObject_ProdOptions
                                                        ON MILinkObject_ProdOptions.MovementItemId = MovementItem.Id
                                                       AND MILinkObject_ProdOptions.DescId         = zc_MILinkObject_ProdOptions()
                       LEFT JOIN MovementItemLinkObject AS MILinkObject_ColorPattern
                                                        ON MILinkObject_ColorPattern.MovementItemId = MovementItem.Id
                                                       AND MILinkObject_ColorPattern.DescId         = zc_MILinkObject_ColorPattern()
                       LEFT JOIN MovementItemLinkObject AS MILinkObject_ProdColorPattern
                                                        ON MILinkObject_ProdColorPattern.MovementItemId = MovementItem.Id
                                                       AND MILinkObject_ProdColorPattern.DescId         = zc_MILinkObject_ProdColorPattern()
                       LEFT JOIN MovementItemFloat AS MIFloat_AmountBasis
                                                   ON MIFloat_AmountBasis.MovementItemId = MovementItem.Id
                                                  AND MIFloat_AmountBasis.DescId         = zc_MIFloat_AmountBasis()
                       LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                   ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                  AND MIFloat_AmountPartner.DescId         = zc_MIFloat_AmountPartner() 
                  WHERE MovementItem.MovementId = inMovementId_OrderClient
                    AND MovementItem.DescId     = zc_MI_Child()
                    AND MovementItem.isErased   = FALSE
                  )

    , tmpSumm AS (SELECT tmpitem.ParentId
                            , SUM (tmpitem.Amount) AS Amount_unit
                            , STRING_AGG (DISTINCT COALESCE (MIString_PartNumber.ValueData, ''), '; ') AS PartNumber
                            , STRING_AGG (DISTINCT COALESCE (Object_Unit.ValueData, ''), '; ')         AS UnitName
                       FROM tmpitem
                            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpitem.UnitId
                            LEFT JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = tmpitem.PartionId
                            LEFT JOIN MovementItemString AS MIString_PartNumber
                                                         ON MIString_PartNumber.MovementItemId = tmpitem.PartionId
                                                        AND MIString_PartNumber.DescId         = zc_MIString_PartNumber()
                       WHERE tmpItem.ParentId > 0
                       GROUP BY tmpItem.ParentId
                      )

    , tmpReceiptLevel AS(SELECT DISTINCT
                                tmpItem.ObjectId AS GoodsId
                              , Object_ReceiptLevel.ValueData :: TVarChar AS ReceiptLevelName
                         FROM tmpItem
                             LEFT JOIN ObjectLink AS ObjectLink_ReceiptProdModelChild_Object
                                                  ON ObjectLink_ReceiptProdModelChild_Object.ChildObjectId = tmpItem.ObjectId
                                                 AND ObjectLink_ReceiptProdModelChild_Object.DescId   = zc_ObjectLink_ReceiptProdModelChild_Object()
                             ---берем  не удаленные
                             INNER JOIN Object AS Object_ReceiptProdModelChild ON Object_ReceiptProdModelChild.Id = ObjectLink_ReceiptProdModelChild_Object.ObjectId
                                                                              AND Object_ReceiptProdModelChild.IsErased = FALSE
                             -- ReceiptProdModel по лодке
                             INNER JOIN ObjectLink AS ObjectLink_ReceiptProdModel
                                                   ON ObjectLink_ReceiptProdModel.ObjectId = ObjectLink_ReceiptProdModelChild_Object.ObjectId
                                                  AND ObjectLink_ReceiptProdModel.DescId = zc_ObjectLink_ReceiptProdModelChild_ReceiptProdModel()
                                                  AND ObjectLink_ReceiptProdModel.ChildObjectId = vbReceiptProdModelId
                 
                             LEFT JOIN ObjectLink AS ObjectLink_ReceiptProdModelChild_ReceiptLevel
                                                  ON ObjectLink_ReceiptProdModelChild_ReceiptLevel.ObjectId = ObjectLink_ReceiptProdModelChild_Object.ObjectId
                                                 AND ObjectLink_ReceiptProdModelChild_ReceiptLevel.DescId   = zc_ObjectLink_ReceiptProdModelChild_ReceiptLevel()
                             LEFT JOIN Object AS Object_ReceiptLevel ON Object_ReceiptLevel.Id = ObjectLink_ReceiptProdModelChild_ReceiptLevel.ChildObjectId
                         )


       -- Результат
      SELECT Object_Object.Id                         AS ObjectId
           , Object_Object.ObjectCode                 AS ObjectCode
           , ObjectString_Article_Object.ValueData    AS Article_Object
           , Object_Object.ValueData                  AS ObjectName
           , ObjectDesc_Object.ItemName               AS DescName

           , 0 :: Integer                             AS UnitId
           , tmpSumm.UnitName :: TVarChar             AS UnitName
           , Object_Partner.Id                        AS PartnerId
           , Object_Partner.ValueData                 AS PartnerName

           , tmpItem.AmountBasis                     AS Amount_basis   -- Количество шаблон сборки
           , CASE WHEN ObjectDesc_Object.Id = zc_Object_Goods()          THEN COALESCE (tmpSumm.Amount_unit, tmpItem.Amount) ELSE 0 END ::TFloat   AS Amount_unit    -- Количество резерв
           , CASE WHEN ObjectDesc_Object.Id = zc_Object_ReceiptService() THEN COALESCE (tmpSumm.Amount_unit, tmpItem.Amount) ELSE 0 END ::TFloat   AS Value_service  -- работы/услуги
           
           , tmpItem.AmountPartner                   AS Amount_partner -- Количество заказ поставщику

           , ObjectString_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_GoodsGroup.ValueData    AS GoodsGroupName
           , Object_Measure.ValueData       AS MeasureName
           , Object_GoodsTag.ValueData      AS GoodsTagName
           , Object_GoodsType.ValueData     AS GoodsTypeName
           , Object_ProdOptions.ValueData   AS ProdOptionsName

           , Movement_OrderPartner.Id                                   AS MovementId_OrderPartner
           , zfConvert_StringToNumber (Movement_OrderPartner.InvNumber) AS InvNumber
           , Movement_OrderPartner.OperDate
           , MovementDate_OperDatePartner.ValueData AS OperDatePartner

           , tmpSumm.PartNumber :: TVarChar AS PartNumber
           , tmpReceiptLevel.ReceiptLevelName :: TVarChar AS ReceiptLevelName
       FROM tmpItem
            LEFT JOIN tmpSumm      ON tmpSumm.ParentId     = tmpItem.MovementItemId

            LEFT JOIN Object AS Object_Object ON Object_Object.Id = tmpItem.ObjectId
            LEFT JOIN ObjectString AS ObjectString_Article_object
                                   ON ObjectString_Article_object.ObjectId = Object_Object.Id
                                  AND ObjectString_Article_object.DescId   = zc_ObjectString_Article()
            LEFT JOIN ObjectDesc AS ObjectDesc_Object ON ObjectDesc_Object.Id = Object_Object.DescId

            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpItem.UnitId

            LEFT JOIN ObjectString AS ObjectString_GoodsGroupFull
                                   ON ObjectString_GoodsGroupFull.ObjectId = tmpItem.ObjectId
                                  AND ObjectString_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()
            LEFT JOIN ObjectLink AS ObjectLink_ProdColor
                                 ON ObjectLink_ProdColor.ObjectId = tmpItem.ObjectId
                                AND ObjectLink_ProdColor.DescId   = zc_ObjectLink_Goods_ProdColor()
            LEFT JOIN ObjectLink AS ObjectLink_GoodsTag
                                 ON ObjectLink_GoodsTag.ObjectId = tmpItem.ObjectId
                                AND ObjectLink_GoodsTag.DescId   = zc_ObjectLink_Goods_GoodsTag()
            LEFT JOIN ObjectLink AS ObjectLink_GoodsType
                                 ON ObjectLink_GoodsType.ObjectId = tmpItem.ObjectId
                                AND ObjectLink_GoodsType.DescId   = zc_ObjectLink_Goods_GoodsType()
            LEFT JOIN ObjectLink AS ObjectLink_Measure
                                 ON ObjectLink_Measure.ObjectId = tmpItem.ObjectId
                                AND ObjectLink_Measure.DescId   = zc_ObjectLink_Goods_Measure()
            LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup
                                 ON ObjectLink_GoodsGroup.ObjectId = tmpItem.ObjectId
                                AND ObjectLink_GoodsGroup.DescId   = zc_ObjectLink_Goods_GoodsGroup()

            LEFT JOIN Object AS Object_ProdOptions ON Object_ProdOptions.Id = tmpItem.ProdOptionsId

            LEFT JOIN Object AS Object_Partner     ON Object_Partner.Id     = tmpItem.PartnerId
            LEFT JOIN Object AS Object_GoodsGroup  ON Object_GoodsGroup.Id  = ObjectLink_GoodsGroup.ChildObjectId
            LEFT JOIN Object AS Object_Measure     ON Object_Measure.Id     = ObjectLink_Measure.ChildObjectId
            LEFT JOIN Object AS Object_GoodsTag    ON Object_GoodsTag.Id    = ObjectLink_GoodsTag.ChildObjectId
            LEFT JOIN Object AS Object_GoodsType   ON Object_GoodsType.Id   = ObjectLink_GoodsType.ChildObjectId
            LEFT JOIN Object AS Object_ProdColor   ON Object_ProdColor.Id   = ObjectLink_ProdColor.ChildObjectId

            LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                        ON MIFloat_MovementId.MovementItemId = tmpItem.MovementItemId
                                       AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()
            LEFT JOIN Movement AS Movement_OrderPartner ON Movement_OrderPartner.Id = MIFloat_MovementId.ValueData :: Integer
            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId = Movement_OrderPartner.Id
                                  AND MovementDate_OperDatePartner.DescId     = zc_MovementDate_OperDatePartner()
            LEFT JOIN tmpReceiptLevel ON tmpReceiptLevel.GoodsId = tmpItem.ObjectId

       -- без этой структуры
       WHERE tmpItem.GoodsId  = 0
         AND tmpItem.ParentId = 0
       ;

     RETURN NEXT Cursor2;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.05.22          *
*/

-- тест
--