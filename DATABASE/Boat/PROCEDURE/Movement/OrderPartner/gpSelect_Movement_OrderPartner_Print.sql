-- Function: gpSelect_Movement_OrderPartner_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_OrderPartner_Print (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_OrderPartner_Print(
    IN inMovementId                 Integer  , -- ключ Документа
    IN inSession                    TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;  

    DECLARE vbDiscountTax TFloat;
    DECLARE vbVATPercent   TFloat;
    DECLARE vbPriceWithVAT Boolean;
    DECLARE vbToId         Integer;
    DECLARE vbFromId       Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Check());
    vbUserId:= inSession;

    --
    SELECT MovementBoolean_PriceWithVAT.ValueData  AS PriceWithVAT
         , MovementFloat_VATPercent.ValueData      AS VATPercent
         , MovementFloat_DiscountTax.ValueData     AS DiscountTax
         , MovementLinkObject_From.ObjectId        AS FromId
         , MovementLinkObject_To.ObjectId          AS ToId
    INTO
        vbPriceWithVAT
      , vbVATPercent
      , vbDiscountTax
      , vbFromId
      , vbToId
    FROM Movement AS Movement_OrderPartner
        LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                  ON MovementBoolean_PriceWithVAT.MovementId = Movement_OrderPartner.Id
                                 AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()

        LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                ON MovementFloat_VATPercent.MovementId = Movement_OrderPartner.Id
                               AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()

        LEFT JOIN MovementFloat AS MovementFloat_DiscountTax
                                ON MovementFloat_DiscountTax.MovementId = Movement_OrderPartner.Id
                               AND MovementFloat_DiscountTax.DescId = zc_MovementFloat_DiscountTax()

        LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                     ON MovementLinkObject_From.MovementId = Movement_OrderPartner.Id
                                    AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()

        LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                     ON MovementLinkObject_To.MovementId = Movement_OrderPartner.Id
                                    AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

    WHERE Movement_OrderPartner.Id = inMovementId
      AND Movement_OrderPartner.DescId = zc_Movement_OrderPartner();


    OPEN Cursor1 FOR

        SELECT 
            Movement_OrderPartner.Id                  AS MovementId
          , Movement_OrderPartner.InvNumber           AS InvNumber
          , CASE WHEN COALESCE (MovementString_InvNumberPartner.ValueData,'') <> ''  THEN MovementString_InvNumberPartner.ValueData ELSE '' END ::TVarChar AS InvNumberPartner
          , Movement_OrderPartner.OperDate            AS OperDate

          , COALESCE (vbPriceWithVAT, FALSE) ::Boolean AS PriceWithVAT
          , vbVATPercent                     ::TFloat  AS VATPercent
          , vbDiscountTax                    ::TFloat  AS DiscountTax

          , MovementFloat_TotalSummMVAT.ValueData      AS TotalSummMVAT
          , MovementFloat_TotalSummPVAT.ValueData      AS TotalSummPVAT
          , MovementFloat_TotalSumm.ValueData          AS TotalSumm
          , (COALESCE (MovementFloat_TotalSummPVAT.ValueData,0) - COALESCE (MovementFloat_TotalSummMVAT.ValueData,0)) :: TFloat AS TotalSummVAT

          , Object_From.Id                            AS FromId
          , Object_From.ValueData                     AS FromName
          , Object_To.Id                              AS ToId      
          , Object_To.ValueData                       AS ToName
          , COALESCE (MovementString_Comment.ValueData,'') :: TVarChar AS Comment

          --
          , tmpInfo.Mail           ::TVarChar AS Mail
          , tmpInfo.WWW            ::TVarChar AS WWW
          , tmpInfo.Name_main      ::TVarChar AS Name_main
          , tmpInfo.Street_main    ::TVarChar AS Street_main
          , tmpInfo.City_main      ::TVarChar AS City_main
          , tmpInfo.Country_Firma  ::TVarChar AS Country_main

          , Object_To.ValueData            ::TVarChar AS Name_Firma
          , ObjectString_Street.ValueData  ::TVarChar AS Street_Firma
          , ObjectString_City.ValueData    ::TVarChar AS City_Firma
          , Object_Country.ValueData       ::TVarChar AS Country_Firma
          , ''                             ::TVarChar AS Text1
          , tmpInfo.Text_Freight           ::TVarChar AS Text2
          , (' '||tmpInfo.Text_sign ||' '|| Object_Insert.ValueData ::TVarChar)  ::TVarChar AS Text3
          , ('<b>USt-IdNr.:</b> ' || COALESCE (ObjectString_TaxNumber.ValueData,'') ) ::TVarChar AS TaxNumber

          , tmpInfo.Footer1        ::TVarChar AS Footer1
          , tmpInfo.Footer2        ::TVarChar AS Footer2
          , tmpInfo.Footer3        ::TVarChar AS Footer3
          , tmpInfo.Footer4        ::TVarChar AS Footer4
          , tmpInfo.Footer_bank    ::TVarChar AS Footer_bank
          , tmpInfo.Footer_user    ::TVarChar AS Footer_user

        FROM Movement AS Movement_OrderPartner 
            LEFT JOIN Object AS Object_To ON Object_To.Id = vbToId
            LEFT JOIN Object AS Object_From ON Object_From.Id = vbFromId

            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId = Movement_OrderPartner.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId = Movement_OrderPartner.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummPVAT
                                    ON MovementFloat_TotalSummPVAT.MovementId = Movement_OrderPartner.Id
                                   AND MovementFloat_TotalSummPVAT.DescId = zc_MovementFloat_TotalSummPVAT()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummMVAT
                                    ON MovementFloat_TotalSummMVAT.MovementId = Movement_OrderPartner.Id
                                   AND MovementFloat_TotalSummMVAT.DescId = zc_MovementFloat_TotalSummMVAT()

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement_OrderPartner.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementLinkObject AS MLO_Insert
                                         ON MLO_Insert.MovementId = Movement_OrderPartner.Id
                                        AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId
            --
            LEFT JOIN Object_Product_PrintInfo_View AS tmpInfo ON 1=1

         -- LEFT JOIN Object AS Object_Client ON Object_Client.Id = tmpInvoice.ObjectId
          LEFT JOIN ObjectString AS ObjectString_Street
                                 ON ObjectString_Street.ObjectId = Object_To.Id
                                AND ObjectString_Street.DescId  IN (zc_ObjectString_Client_Street(), zc_ObjectString_Partner_Street())

          LEFT JOIN ObjectLink AS ObjectLink_PLZ
                               ON ObjectLink_PLZ.ObjectId = Object_To.Id
                              AND ObjectLink_PLZ.DescId   IN (zc_ObjectLink_Client_PLZ(), zc_ObjectLink_Partner_PLZ())
          LEFT JOIN Object AS Object_PLZ ON Object_PLZ.Id = ObjectLink_PLZ.ChildObjectId
          LEFT JOIN ObjectString AS ObjectString_City
                                 ON ObjectString_City.ObjectId = Object_PLZ.Id
                                AND ObjectString_City.DescId = zc_ObjectString_PLZ_City()
          LEFT JOIN ObjectLink AS ObjectLink_Country
                               ON ObjectLink_Country.ObjectId = Object_PLZ.Id
                              AND ObjectLink_Country.DescId = zc_ObjectLink_PLZ_Country()
          LEFT JOIN Object AS Object_Country ON Object_Country.Id = ObjectLink_Country.ChildObjectId

          LEFT JOIN ObjectString AS ObjectString_TaxNumber
                                 ON ObjectString_TaxNumber.ObjectId = Object_To.Id
                                AND ObjectString_TaxNumber.DescId IN (zc_ObjectString_Client_TaxNumber(), zc_ObjectString_Partner_TaxNumber())

        WHERE Movement_OrderPartner.Id = inMovementId
          AND Movement_OrderPartner.DescId = zc_Movement_OrderPartner();

    RETURN NEXT Cursor1;


    OPEN Cursor2 FOR
    WITH
    tmpMI AS (SELECT MovementItem.Id
                   , MovementItem.ObjectId   AS GoodsId
                   , MovementItem.Amount
                   , MIFloat_OperPrice.ValueData     AS OperPrice
                   , COALESCE (MIFloat_CountForPrice.ValueData, 1)   AS CountForPrice
                   , CASE WHEN vbPriceWithVAT THEN MIFloat_OperPrice.ValueData
                                              ELSE zfCalc_SummWVAT (MIFloat_OperPrice.ValueData, vbVATPercent) 
                     END ::TFloat AS OperPriceWithVAT
                    -- Цена без скидки
                  
                   , MIString_Comment.ValueData  AS Comment

              FROM MovementItem

                 LEFT JOIN MovementItemFloat AS MIFloat_OperPrice
                                             ON MIFloat_OperPrice.MovementItemId = MovementItem.Id
                                            AND MIFloat_OperPrice.DescId = zc_MIFloat_OperPrice()

                 LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                             ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                            AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

                 LEFT JOIN MovementItemString AS MIString_Comment
                                              ON MIString_Comment.MovementItemId = MovementItem.Id
                                             AND MIString_Comment.DescId = zc_MIString_Comment()
              WHERE MovementItem.MovementId = inMovementId
                AND MovementItem.DescId     = zc_MI_Master()
                AND MovementItem.isErased   = FALSE
              )

  , tmpGoodsParams AS (SELECT tmpGoods.GoodsId
                            , ObjectString_Article.ValueData     AS Article
                            , Object_GoodsGroup.Id               AS GoodsGroupId
                            , Object_GoodsGroup.ValueData        AS GoodsGroupName
                            , ObjectString_GoodsGroupFull.ValueData AS GoodsGroupNameFull
                            , Object_Measure.Id                  AS MeasureId
                            , Object_Measure.ValueData           AS MeasureName
                            , Object_GoodsTag.Id                 AS GoodsTagId
                            , Object_GoodsTag.ValueData          AS GoodsTagName
                            , Object_GoodsType.Id                AS GoodsTypeId
                            , Object_GoodsType.ValueData         AS GoodsTypeName
                            , Object_GoodsSize.Id                AS GoodsSizeId
                            , Object_GoodsSize.ValueData         AS GoodsSizeName
                            , Object_ProdColor.Id                AS ProdColorId
                            , Object_ProdColor.ValueData         AS ProdColorName
                            , Object_Engine.Id                   AS EngineId
                            , Object_Engine.ValueData            AS EngineName
                       FROM (SELECT DISTINCT tmpMI.GoodsId FROM tmpMI) AS tmpGoods
                           LEFT JOIN ObjectString AS ObjectString_Article
                                                  ON ObjectString_Article.ObjectId = tmpGoods.GoodsId
                                                 AND ObjectString_Article.DescId = zc_ObjectString_Article()

                           LEFT JOIN ObjectString AS ObjectString_GoodsGroupFull
                                                  ON ObjectString_GoodsGroupFull.ObjectId = tmpGoods.GoodsId
                                                 AND ObjectString_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

                           LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                                ON ObjectLink_Goods_GoodsGroup.ObjectId = tmpGoods.GoodsId
                                               AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
                           LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

                           LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                ON ObjectLink_Goods_Measure.ObjectId = tmpGoods.GoodsId
                                               AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                           LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

                           LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsTag
                                                ON ObjectLink_Goods_GoodsTag.ObjectId = tmpGoods.GoodsId
                                               AND ObjectLink_Goods_GoodsTag.DescId = zc_ObjectLink_Goods_GoodsTag()
                           LEFT JOIN Object AS Object_GoodsTag ON Object_GoodsTag.Id = ObjectLink_Goods_GoodsTag.ChildObjectId
              
                           LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsType
                                                ON ObjectLink_Goods_GoodsType.ObjectId = tmpGoods.GoodsId
                                               AND ObjectLink_Goods_GoodsType.DescId   = zc_ObjectLink_Goods_GoodsType()
                           LEFT JOIN Object AS Object_GoodsType ON Object_GoodsType.Id = ObjectLink_Goods_GoodsType.ChildObjectId
              
                           LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsSize
                                                ON ObjectLink_Goods_GoodsSize.ObjectId = tmpGoods.GoodsId
                                               AND ObjectLink_Goods_GoodsSize.DescId = zc_ObjectLink_Goods_GoodsSize()
                           LEFT JOIN Object AS Object_GoodsSize ON Object_GoodsSize.Id = ObjectLink_Goods_GoodsSize.ChildObjectId
              
                           LEFT JOIN ObjectLink AS ObjectLink_Goods_ProdColor
                                                ON ObjectLink_Goods_ProdColor.ObjectId = tmpGoods.GoodsId
                                               AND ObjectLink_Goods_ProdColor.DescId = zc_ObjectLink_Goods_ProdColor()
                           LEFT JOIN Object AS Object_ProdColor ON Object_ProdColor.Id = ObjectLink_Goods_ProdColor.ChildObjectId

                           LEFT JOIN ObjectLink AS ObjectLink_Goods_Engine
                                                ON ObjectLink_Goods_Engine.ObjectId = tmpGoods.GoodsId
                                               AND ObjectLink_Goods_Engine.DescId = zc_ObjectLink_Goods_Engine()
                           LEFT JOIN Object AS Object_Engine ON Object_Engine.Id = ObjectLink_Goods_Engine.ChildObjectId
                       )

     --РЕЗУЛЬТАТ
     SELECT
            MovementItem.Id           AS Id
          , MovementItem.GoodsId      AS GoodsId
          , Object_Goods.ObjectCode   AS GoodsCode
          , Object_Goods.ValueData    AS GoodsName
          , ObjectDesc.ItemName       AS DescName
          , MovementItem.Amount           ::TFloat
          , MovementItem.CountForPrice    ::TFloat
          , MovementItem.OperPrice        ::TFloat
          , MovementItem.OperPriceWithVAT ::TFloat

          , zfCalc_SummIn (COALESCE (MovementItem.Amount, 0), MovementItem.OperPrice, MovementItem.CountForPrice)        ::TFloat AS Summ
          , zfCalc_SummIn (COALESCE (MovementItem.Amount, 0), MovementItem.OperPriceWithVAT, MovementItem.CountForPrice) ::TFloat AS SummWithVAT

          , MovementItem.Comment ::TVarChar
         
          --
          , tmpGoodsParams.Article
          , tmpGoodsParams.GoodsGroupId
          , tmpGoodsParams.GoodsGroupName
          , tmpGoodsParams.GoodsGroupNameFull
          , tmpGoodsParams.MeasureId
          , tmpGoodsParams.MeasureName
          , tmpGoodsParams.GoodsTagId
          , tmpGoodsParams.GoodsTagName
          , tmpGoodsParams.GoodsTypeId
          , tmpGoodsParams.GoodsTypeName
          , tmpGoodsParams.GoodsSizeId
          , tmpGoodsParams.GoodsSizeName
          , tmpGoodsParams.ProdColorId
          , tmpGoodsParams.ProdColorName
          , tmpGoodsParams.EngineId
          , tmpGoodsParams.EngineName
          , inMovementId AS MovementId
     FROM tmpMI AS MovementItem
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.GoodsId
          LEFT JOIN tmpGoodsParams AS tmpGoodsParams ON tmpGoodsParams.GoodsId = MovementItem.GoodsId
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Goods.DescId
      ;

    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.04.21         *
*/
-- тест
--select * from gpSelect_Movement_OrderPartner_Print(inMovementId := 3897397 ,  inSession := '3');
--select * from gpSelect_Movement_OrderPartner_Print(inMovementId := 257 ,  inSession := '5');
