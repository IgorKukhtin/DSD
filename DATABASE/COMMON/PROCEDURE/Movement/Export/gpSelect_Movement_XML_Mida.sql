-- Function: gpSelect_Movement_XML_Mida()

DROP FUNCTION IF EXISTS gpSelect_Movement_XML_Mida (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_XML_Mida(
    IN inMovementId           Integer   ,
    IN inSession              TVarChar    -- сессия пользователя
)
RETURNS TABLE (RowData TBlob)
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbGoodsPropertyId Integer;
   DECLARE vbGoodsPropertyId_basis Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_XML_Mida());
     vbUserId:= lpGetUserBySession (inSession);


     -- Таблица для результата
     CREATE TEMP TABLE _Result (RowData TBlob) ON COMMIT DROP;


     -- параметры из документа
     SELECT zfCalc_GoodsPropertyId (MovementLinkObject_Contract.ObjectId, COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MovementLinkObject_To.ObjectId), MovementLinkObject_To.ObjectId) AS GoodsPropertyId
          , zfCalc_GoodsPropertyId (0, zc_Juridical_Basis(), 0) AS GoodsPropertyId_basis
            INTO vbGoodsPropertyId, vbGoodsPropertyId_basis
     FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                       ON MovementLinkObject_Contract.MovementId = Movement.Id
                                      AND MovementLinkObject_Contract.DescId IN (zc_MovementLinkObject_Contract(), zc_MovementLinkObject_ContractTo())
          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                               ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                              AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
     WHERE Movement.Id = inMovementId
    ;


     -- первые строчки XML
     -- INSERT INTO _Result(RowData) VALUES ('<?xml version="1.0" encoding="windows-1251"?>');
     INSERT INTO _Result(RowData) VALUES ('<?xml version="1.0" encoding="UTF-16"?>');
     INSERT INTO _Result(RowData) VALUES ('<root>');

     -- Шапка
     INSERT INTO _Result(RowData)
        SELECT '<head КодПоставщика="226"'
                  ||    ' Direction="' || COALESCE (ObjectString_RoomNumber.ValueData, '') ||'"'
                  || ' ДатаОперации="' || zfConvert_DateToString (MovementDate_OperDatePartner.ValueData) ||'"'
                  ||' НомерОперации="' || Movement.InvNumber ||'"'
                  ||  ' НомерЗаказа="' || COALESCE (MovementString_InvNumberOrder.ValueData, '') ||'"'
                  ||  ' ВидОперации="2">'
        FROM Movement
             LEFT JOIN MovementString AS MovementString_InvNumberOrder
                                      ON MovementString_InvNumberOrder.MovementId =  Movement.Id
                                     AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()
             LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                    ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                   AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
             LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                          ON MovementLinkObject_To.MovementId = Movement.Id
                                         AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
             LEFT JOIN ObjectString AS ObjectString_RoomNumber
                                    ON ObjectString_RoomNumber.ObjectId = MovementLinkObject_To.ObjectId
                                   AND ObjectString_RoomNumber.DescId = zc_ObjectString_Partner_RoomNumber()
        WHERE Movement.Id = inMovementId
       ;

     -- Строчная часть
     INSERT INTO _Result(RowData)
        WITH tmpObject_GoodsPropertyValue AS
                (SELECT ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                      , ObjectLink_GoodsPropertyValue_Goods.ChildObjectId                   AS GoodsId
                      , COALESCE (ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId, 0) AS GoodsKindId
                      , ObjectString_BarCode.ValueData       AS BarCode
                 FROM (SELECT vbGoodsPropertyId AS GoodsPropertyId WHERE vbGoodsPropertyId <> 0
                      ) AS tmpGoodsProperty
                      INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                            ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = tmpGoodsProperty.GoodsPropertyId
                                           AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
                      LEFT JOIN ObjectString AS ObjectString_BarCode
                                             ON ObjectString_BarCode.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                            AND ObjectString_BarCode.DescId = zc_ObjectString_GoodsPropertyValue_BarCode()
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
                 FROM (SELECT MAX (tmpObject_GoodsPropertyValue.ObjectId) AS ObjectId, GoodsId FROM tmpObject_GoodsPropertyValue WHERE BarCode <> '' GROUP BY GoodsId
                      ) AS tmpGoodsProperty_find
                      LEFT JOIN tmpObject_GoodsPropertyValue ON tmpObject_GoodsPropertyValue.ObjectId =  tmpGoodsProperty_find.ObjectId
                )
           , tmpObject_GoodsPropertyValue_basis AS
                (SELECT ObjectLink_GoodsPropertyValue_Goods.ChildObjectId AS GoodsId
                      , COALESCE (ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId, 0) AS GoodsKindId
                      , ObjectString_BarCode.ValueData       AS BarCode
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
                )
        -- результат
        SELECT '<tov КодРегистра="' || COALESCE (tmpObject_GoodsPropertyValue.BarCode, COALESCE (tmpObject_GoodsPropertyValueGroup.BarCode, COALESCE (tmpObject_GoodsPropertyValue.BarCode, ''))) || '"'
               || ' Наименование="' || REPLACE (Object_Goods.ValueData, '"', '') || CASE WHEN COALESCE (MILinkObject_GoodsKind.ObjectId, zc_Enum_GoodsKind_Main()) = zc_Enum_GoodsKind_Main() THEN '' ELSE ' ' || Object_GoodsKind.ValueData END || '"'
               || ' Количество="' || (MIFloat_AmountPartner.ValueData :: NUMERIC (16, 3)) :: TVarChar || '"'
               || ' Цена="' || CASE WHEN MIFloat_CountForPrice.ValueData > 1 THEN CAST (1.2 * MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 3)) :: TVarChar ELSE CAST (1.2 * MIFloat_Price.ValueData AS NUMERIC (16, 3)) :: TVarChar END || '"'
               || '/>'
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
                                                   AND tmpObject_GoodsPropertyValue.BarCode <> ''
             LEFT JOIN tmpObject_GoodsPropertyValueGroup ON tmpObject_GoodsPropertyValueGroup.GoodsId = MovementItem.ObjectId
                                                        AND tmpObject_GoodsPropertyValue.GoodsId IS NULL
             LEFT JOIN tmpObject_GoodsPropertyValue_basis ON tmpObject_GoodsPropertyValue_basis.GoodsId = MovementItem.ObjectId
                                                         AND tmpObject_GoodsPropertyValue_basis.GoodsKindId = COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
             LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

        WHERE MovementItem.MovementId = inMovementId
          AND MovementItem.DescId = zc_MI_Master()
          AND MovementItem.isErased = FALSE
          AND MIFloat_AmountPartner.ValueData <> 0
       ;

     -- последние строчки XML
     INSERT INTO _Result(RowData) VALUES ('</head>');
     INSERT INTO _Result(RowData) VALUES ('</root>');


     -- Результат
     RETURN QUERY
        SELECT _Result.RowData from _Result;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 25.02.16                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_XML_Mida (inMovementId:= 3229861, inSession:= zfCalc_UserAdmin())
