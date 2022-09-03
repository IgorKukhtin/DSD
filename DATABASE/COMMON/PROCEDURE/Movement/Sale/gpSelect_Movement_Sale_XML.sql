-- Function:  gpSelect_Movement_Sale_XML()

DROP FUNCTION IF EXISTS gpSelect_Movement_Sale_XML (Integer, TVarChar);

CREATE OR REPLACE FUNCTION  gpSelect_Movement_Sale_XML(
    IN inMovementId   Integer  ,  -- Подразделение
    IN inSession                  TVarChar    -- сессия пользователя
)
RETURNS TABLE (RowData TBlob)
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbPartnerId       Integer;
   DECLARE vbOperDatePartner TDateTime;
   DECLARE vbOperDate        TDateTime;
   DECLARE vbInvnumber       TVarChar;
   DECLARE vbGoodsPropertyId Integer;
   DECLARE vbGoodsPropertyId_basis Integer;
   

   DECLARE vbPaidKindId Integer;
   DECLARE vbChangePercent TFloat;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

     -- параметры из документа
     SELECT Movement.OperDate AS OperDate
          , MovementDate_OperDatePartner.ValueData AS OperDatePartner
          , Movement.Invnumber
          , Object_Partner.Id AS PartnerId
          , zfCalc_GoodsPropertyId (MovementLinkObject_Contract.ObjectId, COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, Object_Partner.Id), Object_Partner.Id) AS GoodsPropertyId
          , zfCalc_GoodsPropertyId (0, zc_Juridical_Basis(), 0) AS GoodsPropertyId_basis
          , COALESCE (MovementFloat_ChangePercent.ValueData, 0) AS ChangePercent      
   INTO vbOperDate, vbOperDatePartner, vbInvnumber, vbPartnerId ,vbGoodsPropertyId, vbGoodsPropertyId_basis, vbChangePercent
     FROM Movement
          LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                 ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                AND MovementDate_OperDatePartner.DescId     = zc_MovementDate_OperDatePartner()
          LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                  ON MovementFloat_ChangePercent.MovementId = Movement.Id
                                 AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                       ON MovementLinkObject_Contract.MovementId = Movement.Id
                                      AND MovementLinkObject_Contract.DescId IN (zc_MovementLinkObject_Contract(), zc_MovementLinkObject_ContractTo())
          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = MovementLinkObject_To.ObjectId
          LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                               ON ObjectLink_Partner_Juridical.ObjectId = Object_Partner.Id
                              AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
          LEFT JOIN ObjectBoolean AS ObjectBoolean_isDiscountPrice
                                  ON ObjectBoolean_isDiscountPrice.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                 AND ObjectBoolean_isDiscountPrice.DescId = zc_ObjectBoolean_Juridical_isDiscountPrice()
     WHERE Movement.Id = inMovementId
    ;

    -- Таблица для результата
    CREATE TEMP TABLE _Result (RowData TBlob) ON COMMIT DROP;
     
    -- первые строчки XML
    INSERT INTO _Result( RowData) VALUES ( '<?xml version= "1.0" encoding= "windows-1251"?>');

     --INSERT INTO _Result(RowData) VALUES ('<?xml version="1.0" encoding="UTF-16"?>');
     INSERT INTO _Result(RowData) VALUES ('<SaleOrder>');

     -- Шапка
     INSERT INTO _Result(RowData)
        SELECT '<Header>'
              || '<DocumentNumber>' || vbInvnumber ||'</DocumentNumber>'
              || '<DocumentDate>' || TO_CHAR(vbOperDate, 'yyyy-mm-dd')  ||'</DocumentDate>'          
              || '</Header> '
        ;

      --    
     
     -- строки  
     INSERT INTO _Result(RowData) VALUES ('<Body>');
     
     INSERT INTO _Result(RowData)
        WITH tmpObject_GoodsPropertyValue AS
                (SELECT ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                      , ObjectLink_GoodsPropertyValue_Goods.ChildObjectId                   AS GoodsId
                      , COALESCE (ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId, 0) AS GoodsKindId
                      , ObjectString_BarCode.ValueData                                      AS BarCode
                      , ObjectString_Article.ValueData                                      AS Article
                 FROM (SELECT vbGoodsPropertyId AS GoodsPropertyId WHERE vbGoodsPropertyId <> 0
                      ) AS tmpGoodsProperty
                      INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                            ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = tmpGoodsProperty.GoodsPropertyId
                                           AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()

                      LEFT JOIN ObjectString AS ObjectString_BarCode
                                             ON ObjectString_BarCode.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                            AND ObjectString_BarCode.DescId = zc_ObjectString_GoodsPropertyValue_BarCode()
                      LEFT JOIN ObjectString AS ObjectString_Article
                                             ON ObjectString_Article.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                            AND ObjectString_Article.DescId = zc_ObjectString_GoodsPropertyValue_Article()

                      LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                           ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                          AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
                      LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                           ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                          AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
                )
           , tmpObject_GoodsPropertyValueGroup AS
                (SELECT tmpObject_GoodsPropertyValue.GoodsId
                      , tmpObject_GoodsPropertyValue.BarCode
                      , tmpObject_GoodsPropertyValue.Article
                 FROM (SELECT MAX (tmpObject_GoodsPropertyValue.ObjectId) AS ObjectId, GoodsId FROM tmpObject_GoodsPropertyValue WHERE Article <> '' GROUP BY GoodsId
                      ) AS tmpGoodsProperty_find
                      LEFT JOIN tmpObject_GoodsPropertyValue ON tmpObject_GoodsPropertyValue.ObjectId =  tmpGoodsProperty_find.ObjectId
                )
           , tmpObject_GoodsPropertyValue_basis AS
                (SELECT ObjectLink_GoodsPropertyValue_Goods.ChildObjectId AS GoodsId
                      , COALESCE (ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId, 0) AS GoodsKindId
                      , ObjectString_BarCode.ValueData                                      AS BarCode
                      , ObjectString_Article.ValueData                                      AS Article
                 FROM (SELECT vbGoodsPropertyId_basis AS GoodsPropertyId
                      ) AS tmpGoodsProperty
                      INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                            ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = tmpGoodsProperty.GoodsPropertyId
                                           AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()

                      LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                           ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                          AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
                      LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                           ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                          AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()

                      LEFT JOIN ObjectString AS ObjectString_BarCode
                                             ON ObjectString_BarCode.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                            AND ObjectString_BarCode.DescId = zc_ObjectString_GoodsPropertyValue_BarCode()
                      LEFT JOIN ObjectString AS ObjectString_Article
                                             ON ObjectString_Article.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                            AND ObjectString_Article.DescId = zc_ObjectString_GoodsPropertyValue_Article()
                )
        -- результат
        SELECT 
               '<Item>'
               || ' <PositionNumber>' || tmp.Ord :: TVarChar        || '</PositionNumber>' 
               || ' <ProductCode>' || tmp.Article :: TVarChar    || '</ProductCode>'  
               || ' <UnitCode>'    || tmp.MeasureName ::TVarChar || '</UnitCode>'
               || ' <ProductName>' || tmp.GoodsName   || '</ProductName>'
               || ' <Quantity>' || tmp.AmountPartner :: TVarChar|| '</Quantity>'
               || ' <Price>' || tmp.Price :: TVarChar || '</Price>'
               || ' <Sum>' || tmp.Sum :: TVarChar   || '</Sum>'
               || '</Item>' 
        FROM (SELECT ROW_NUMBER() OVER (ORDER BY MovementItem.Id) AS Ord
                   , COALESCE (tmpObject_GoodsPropertyValue.Article, COALESCE (tmpObject_GoodsPropertyValueGroup.Article, COALESCE (tmpObject_GoodsPropertyValue.Article, ''))):: TVarChar AS Article
                   , Object_Measure.ValueData :: TVarChar AS MeasureName  
                   , (REPLACE (Object_Goods.ValueData, '"', '') || CASE WHEN COALESCE (MILinkObject_GoodsKind.ObjectId, zc_Enum_GoodsKind_Main()) = zc_Enum_GoodsKind_Main() THEN '' ELSE ' ' || Object_GoodsKind.ValueData END ):: TVarChar  AS GoodsName
                   , (MIFloat_AmountPartner.ValueData ) :: TVarChar AS AmountPartner
                   , CASE WHEN MIFloat_CountForPrice.ValueData > 1 THEN CAST (MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 3)) :: TVarChar ELSE CAST (MIFloat_Price.ValueData AS NUMERIC (16, 3)) :: TVarChar END AS Price
                   , CAST (MIFloat_AmountPartner.ValueData * CASE WHEN MIFloat_CountForPrice.ValueData > 1 THEN CAST (MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 3)) ELSE CAST (MIFloat_Price.ValueData AS NUMERIC (16, 3)) END AS NUMERIC (16, 3) ) AS Sum 
              FROM MovementItem
                   LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                    ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                   LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                               ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                              AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                   LEFT JOIN MovementItemFloat AS MIFloat_Price
                                               ON MIFloat_Price.MovementItemId = MovementItem.Id
                                              AND MIFloat_Price.DescId = zc_MIFloat_Price()
                   LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                               ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                              AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                   LEFT JOIN tmpObject_GoodsPropertyValue ON tmpObject_GoodsPropertyValue.GoodsId = MovementItem.ObjectId
                                                         AND tmpObject_GoodsPropertyValue.GoodsKindId = COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                                                         AND tmpObject_GoodsPropertyValue.Article <> ''
                   LEFT JOIN tmpObject_GoodsPropertyValueGroup ON tmpObject_GoodsPropertyValueGroup.GoodsId = MovementItem.ObjectId
                                                              AND tmpObject_GoodsPropertyValue.GoodsId IS NULL
                   LEFT JOIN tmpObject_GoodsPropertyValue_basis ON tmpObject_GoodsPropertyValue_basis.GoodsId = MovementItem.ObjectId
                                                               AND tmpObject_GoodsPropertyValue_basis.GoodsKindId = COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                   LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
                   LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

                   LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                        ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                                       AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure() 
                   LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

              WHERE MovementItem.MovementId = inMovementId
                AND MovementItem.DescId = zc_MI_Master()
                AND MovementItem.isErased = FALSE
                AND MIFloat_AmountPartner.ValueData <> 0
             ) AS tmp
       ;

     --последнии строчки XML
     INSERT INTO _Result( RowData) VALUES ('</Body>');  
     
      --последнии строчки XML
     INSERT INTO _Result( RowData) VALUES ('</SaleOrder>');
    
	-- Результат
     RETURN QUERY
        SELECT _Result.RowData FROM _Result ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И. 
 24.07.22         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_Sale_XML(inMovementId :=23087092 , inSession := '3');
