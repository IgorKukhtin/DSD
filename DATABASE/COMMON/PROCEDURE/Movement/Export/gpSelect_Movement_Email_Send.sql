-- Function: gpselect_movement_email_send(integer, tvarchar)

-- DROP FUNCTION gpselect_movement_email_send(integer, tvarchar);

CREATE OR REPLACE FUNCTION gpselect_movement_email_send(
    IN inmovementid integer,
    IN insession tvarchar)
  RETURNS TABLE(rowdata tblob) AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbGoodsPropertyId Integer;
   DECLARE vbGoodsPropertyId_basis Integer;
   DECLARE vbExportKindId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Email_Send());
     vbUserId:= lpGetUserBySession (inSession);


     -- Таблица для результата
     CREATE TEMP TABLE _Result (RowData TBlob) ON COMMIT DROP;


     -- параметры из документа
     SELECT tmp.GoodsPropertyId
          , tmp.GoodsPropertyId_basis
          , tmp.ExportKindId
            INTO vbGoodsPropertyId, vbGoodsPropertyId_basis, vbExportKindId
     FROM
    (WITH tmpExportJuridical AS (SELECT DISTINCT tmp.PartnerId, tmp.ExportKindId FROM lpSelect_Object_ExportJuridical_list() AS tmp)
     SELECT zfCalc_GoodsPropertyId (MovementLinkObject_Contract.ObjectId, COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MovementLinkObject_To.ObjectId), MovementLinkObject_To.ObjectId) AS GoodsPropertyId
          , zfCalc_GoodsPropertyId (0, zc_Juridical_Basis(), 0) AS GoodsPropertyId_basis
          , tmpExportJuridical.ExportKindId
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
          LEFT JOIN tmpExportJuridical ON tmpExportJuridical.PartnerId = MovementLinkObject_To.ObjectId
     WHERE Movement.Id = inMovementId
    ) AS tmp
    ;


     -- !!!1.Формат XML - zc_Enum_ExportKind_Mida35273055!!!

     IF vbExportKindId = zc_Enum_ExportKind_Mida35273055()
     THEN

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
        SELECT --'<tov КодРегистра="' || COALESCE (tmpObject_GoodsPropertyValue.BarCode, COALESCE (tmpObject_GoodsPropertyValueGroup.BarCode, COALESCE (tmpObject_GoodsPropertyValue.BarCode, ''))) || '"'
               '<tov КодРегистра="' || COALESCE (tmpObject_GoodsPropertyValue.Article, COALESCE (tmpObject_GoodsPropertyValueGroup.Article, COALESCE (tmpObject_GoodsPropertyValue.Article, ''))) || '"'
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
                                                   -- AND tmpObject_GoodsPropertyValue.BarCode <> ''
                                                   AND tmpObject_GoodsPropertyValue.Article <> ''
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


     ELSE

     -- !!!2.Формат CSV - zc_Enum_ExportKind_Vez37171990!!!

     IF vbExportKindId = zc_Enum_ExportKind_Vez37171990()
     THEN


     -- первая строчка CSV  - Шапка
     INSERT INTO _Result(RowData)
        SELECT COALESCE (Object_JuridicalBasis.ValueData, 'Alan')
     || ';' || COALESCE (OH_JuridicalDetails_From.OKPO, '')
     || ';' || Movement.InvNumber
     || ';' || COALESCE (ObjectString_GLNCode.ValueData, '') -- || ':V' || COALESCE (ObjectString_RoomNumber.ValueData, '0')
     || ';' || '14' -- Версия формата
     || ';' || 'RN' -- Вид документа : RN – расходная накладная or VN – возвратная накладная or SP - спецификация
     || ';' || zfConvert_DateToString (MovementDate_OperDatePartner.ValueData)
     || ';' || COALESCE (View_Contract.InvNumber, '')
     || ';' || CASE WHEN MovementLinkObject_PaidKind.ObjectId = zc_Enum_PaidKind_FirstForm() THEN '10' ELSE '11' END
        FROM Movement
             LEFT JOIN MovementString AS MovementString_InvNumberOrder
                                      ON MovementString_InvNumberOrder.MovementId =  Movement.Id
                                     AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()
             LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                    ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                   AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

             LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                          ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                         AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
             LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                          ON MovementLinkObject_Contract.MovementId = Movement.Id
                                         AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
             LEFT JOIN Object_Contract_View AS View_Contract ON View_Contract.ContractId = MovementLinkObject_Contract.ObjectId
             LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalDocument
                                  ON ObjectLink_Contract_JuridicalDocument.ObjectId = MovementLinkObject_Contract.ObjectId
                                 AND ObjectLink_Contract_JuridicalDocument.DescId = zc_ObjectLink_Contract_JuridicalDocument()
                                 AND MovementLinkObject_PaidKind.ObjectId = zc_Enum_PaidKind_SecondForm()
             LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalBasis
                                  ON ObjectLink_Contract_JuridicalBasis.ObjectId = MovementLinkObject_Contract.ObjectId
                                 AND ObjectLink_Contract_JuridicalBasis.DescId = zc_ObjectLink_Contract_JuridicalBasis()
             LEFT JOIN Object AS Object_JuridicalBasis ON Object_JuridicalBasis.Id = COALESCE (ObjectLink_Contract_JuridicalDocument.ChildObjectId, ObjectLink_Contract_JuridicalBasis.ChildObjectId)

             LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetails_From
                                                                 ON OH_JuridicalDetails_From.JuridicalId = Object_JuridicalBasis.Id
                                                                AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) >= OH_JuridicalDetails_From.StartDate
                                                                AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) <  OH_JuridicalDetails_From.EndDate

             LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                          ON MovementLinkObject_To.MovementId = Movement.Id
                                         AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
             LEFT JOIN ObjectString AS ObjectString_GLNCode
                                    ON ObjectString_GLNCode.ObjectId = MovementLinkObject_To.ObjectId
                                   AND ObjectString_GLNCode.DescId = zc_ObjectString_Partner_GLNCode()
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
           , tmpGoodsByGoodsKind AS
                (SELECT DISTINCT
                        ObjectLink_GoodsByGoodsKind_Goods.ObjectId                        AS ObjectId
                      , ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId                   AS GoodsId
                      , COALESCE (ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId, 0) AS GoodsKindId
                 FROM ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                      LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                                           ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                          AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
                 WHERE ObjectLink_GoodsByGoodsKind_Goods.DescId = zc_ObjectLink_GoodsByGoodsKind_Goods()
                )

        -- результат
        SELECT tmpGoodsByGoodsKind.ObjectId :: TVarChar
     || ';' || (MIFloat_AmountPartner.ValueData :: NUMERIC (16, 3)) :: TVarChar
               -- Цена с НДС
     || ';' || CASE WHEN MIFloat_CountForPrice.ValueData > 1 THEN CAST (1.2 * MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 3)) ELSE CAST (1.2 * MIFloat_Price.ValueData AS NUMERIC (16, 3)) END :: TVarChar 
     || ';' || REPLACE (Object_Goods.ValueData, '"', '') || CASE WHEN COALESCE (MILinkObject_GoodsKind.ObjectId, zc_Enum_GoodsKind_Main()) = zc_Enum_GoodsKind_Main() THEN '' ELSE ' ' || Object_GoodsKind.ValueData END
     || ';1' -- Коэффициент
     || ';' || COALESCE (Object_Measure.ValueData, '')
               -- Цена без НДС
     || ';' || CASE WHEN MIFloat_CountForPrice.ValueData > 1 THEN CAST (1 * MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 3)) ELSE CAST (1 * MIFloat_Price.ValueData AS NUMERIC (16, 3)) END :: TVarChar
               -- Сумма без НДС
     || ';' || CASE WHEN MIFloat_CountForPrice.ValueData > 1 THEN CAST (1 * MIFloat_AmountPartner.ValueData * MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 2)) ELSE CAST (1 * MIFloat_AmountPartner.ValueData * MIFloat_Price.ValueData AS NUMERIC (16, 2)) END :: TVarChar
               -- Сумма с НДС
     || ';' || COALESCE (MIFloat_Summ.ValueData, 0) :: TVarChar
               -- НДС
     || ';' || (COALESCE (MIFloat_Summ.ValueData, 0)
              - CASE WHEN MIFloat_CountForPrice.ValueData > 1 THEN CAST (1 * MIFloat_AmountPartner.ValueData * MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 2)) ELSE CAST (1 * MIFloat_AmountPartner.ValueData * MIFloat_Price.ValueData AS NUMERIC (16, 2)) END
               ) :: TVarChar
               -- Штрих-код
     || ';' || COALESCE (tmpObject_GoodsPropertyValue.BarCode, COALESCE (tmpObject_GoodsPropertyValueGroup.BarCode, COALESCE (tmpObject_GoodsPropertyValue.BarCode, '')))
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
             LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                         ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                        AND MIFloat_Summ.DescId = zc_MIFloat_Summ()
             LEFT JOIN tmpGoodsByGoodsKind ON tmpGoodsByGoodsKind.GoodsId = MovementItem.ObjectId
                                          AND tmpGoodsByGoodsKind.GoodsKindId = COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
             LEFT JOIN tmpObject_GoodsPropertyValue ON tmpObject_GoodsPropertyValue.GoodsId = MovementItem.ObjectId
                                                   AND tmpObject_GoodsPropertyValue.GoodsKindId = COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                                                   AND tmpObject_GoodsPropertyValue.BarCode <> ''
             LEFT JOIN tmpObject_GoodsPropertyValueGroup ON tmpObject_GoodsPropertyValueGroup.GoodsId = MovementItem.ObjectId
                                                        AND tmpObject_GoodsPropertyValue.GoodsId IS NULL
             LEFT JOIN tmpObject_GoodsPropertyValue_basis ON tmpObject_GoodsPropertyValue_basis.GoodsId = MovementItem.ObjectId
                                                         AND tmpObject_GoodsPropertyValue_basis.GoodsKindId = COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
             LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                  ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                                 AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
             LEFT JOIN Object AS Object_Goods     ON Object_Goods.Id     = MovementItem.ObjectId
             LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId
             LEFT JOIN Object AS Object_Measure   ON Object_Measure.Id   = ObjectLink_Goods_Measure.ChildObjectId

        WHERE MovementItem.MovementId = inMovementId
          AND MovementItem.DescId = zc_MI_Master()
          AND MovementItem.isErased = FALSE
          AND MIFloat_AmountPartner.ValueData <> 0
       ;

     ELSE
     
     -- !!!3.Формат XML - zc_Enum_ExportKind_Brusn34604386!!!

     IF vbExportKindId = zc_Enum_ExportKind_Brusn34604386()
     THEN

     -- первые строчки XML
     -- INSERT INTO _Result(RowData) VALUES ('<?xml version="1.0" encoding="windows-1251"?>');
     INSERT INTO _Result(RowData) VALUES ('<?xml version="1.0" encoding="UTF-16"?>');
     INSERT INTO _Result(RowData) VALUES ('<root>');


     -- первая строчка CSV  - Шапка
--     INSERT INTO _Result(RowData)
--        SELECT 'KOD'       -- штрихкод товара (если такового нет - придумать произвольный с буквенным префиксом) 
--            || ';KOL'      -- количество 
--            || ';CEN'      -- цена с НДС (Ваша) 
--            || ';NAM'      -- имя товара на всяк случай если забыли сообщить штрихкод 
--            || ';KLN'      -- клиент (константа, код поставщика в нашей базе )  - 9990057 
--            || ';MAG'      -- магазин (мы номер магаза по нашей кодификации или ваша кака-нить уникальность ТТ)
--            || ';NAM_TT'   -- название адрес ТТ
--            || ';DAT'      -- дата дока
--            || ';NAK'      -- номер накладной (мало знаков - расширяйте на свое усмотрение)
--       ;

     -- Строчная часть
     INSERT INTO _Result(RowData)
        WITH tmpMovement AS
                (SELECT Movement.Id                                      AS MovementId
                      , Movement.InvNumber                               AS InvNumber
                      , MovementDate_OperDatePartner.ValueData           AS OperDatePartner
                      , MovementLinkObject_To.ObjectId                   AS PartnerId
                      , COALESCE (Object_To.ValueData, '')               AS PartnerName
                      , COALESCE (ObjectString_GLNCode.ValueData, '')    AS GLNCode
                      , COALESCE (ObjectString_RoomNumber.ValueData, '') AS RoomNumber
                 FROM Movement
                      LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                             ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                            AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

                      LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                   ON MovementLinkObject_To.MovementId = Movement.Id
                                                  AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                      LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
                      LEFT JOIN ObjectString AS ObjectString_GLNCode
                                             ON ObjectString_GLNCode.ObjectId = MovementLinkObject_To.ObjectId
                                            AND ObjectString_GLNCode.DescId = zc_ObjectString_Partner_GLNCode()
                      LEFT JOIN ObjectString AS ObjectString_RoomNumber
                                             ON ObjectString_RoomNumber.ObjectId = MovementLinkObject_To.ObjectId
                                            AND ObjectString_RoomNumber.DescId = zc_ObjectString_Partner_RoomNumber()
                 WHERE Movement.Id = inMovementId
                )
           , tmpObject_GoodsPropertyValue AS
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
           , tmpGoodsByGoodsKind AS
                (SELECT DISTINCT
                        ObjectLink_GoodsByGoodsKind_Goods.ObjectId                        AS ObjectId
                      , ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId                   AS GoodsId
                      , COALESCE (ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId, 0) AS GoodsKindId
                 FROM ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                      LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                                           ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                          AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
                 WHERE ObjectLink_GoodsByGoodsKind_Goods.DescId = zc_ObjectLink_GoodsByGoodsKind_Goods()
                )
        -- результат
        SELECT 
        -- штрихкод товара (если такового нет - придумать произвольный с буквенным префиксом)
      '    <tov KOD="' || COALESCE (tmpObject_GoodsPropertyValue.BarCode, COALESCE (tmpObject_GoodsPropertyValueGroup.BarCode, COALESCE (tmpObject_GoodsPropertyValue.BarCode, '')))
               -- количество
     || '" KOL="' || (MIFloat_AmountPartner.ValueData :: NUMERIC (16, 3)) :: TVarChar
               -- цена с НДС (Ваша) 
     || '" CEN="' || CASE WHEN MIFloat_CountForPrice.ValueData > 1 THEN CAST (1.2 * MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 3)) ELSE CAST (1.2 * MIFloat_Price.ValueData AS NUMERIC (16, 3)) END :: TVarChar
               -- имя товара на всяк случай если забыли сообщить штрихкод
     || '" NAM="' || REPLACE (Object_Goods.ValueData, '"', '') || CASE WHEN COALESCE (MILinkObject_GoodsKind.ObjectId, zc_Enum_GoodsKind_Main()) = zc_Enum_GoodsKind_Main() THEN '' ELSE ' ' || Object_GoodsKind.ValueData END
               -- клиент (константа, код поставщика в нашей базе )  - 9990057
     || '" KLN="9990057"'
               -- магазин (мы номер магаза по нашей кодификации или ваша кака-нить уникальность ТТ)
     || ' MAG="' || tmpMovement.PartnerId -- tmpMovement.RoomNumber
               -- название адрес ТТ
     || '" NAM_TT="' || tmpMovement.PartnerName
               -- дата дока
     || '" DAT="' || zfConvert_DateToString (tmpMovement.OperDatePartner)
               -- номер накладной (мало знаков - расширяйте на свое усмотрение)
     || '" NAK="' || tmpMovement.InvNumber || '" />'

        FROM MovementItem
             LEFT JOIN tmpMovement ON tmpMovement.MovementId = MovementItem.MovementId
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
             LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                         ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                        AND MIFloat_Summ.DescId = zc_MIFloat_Summ()
             LEFT JOIN tmpGoodsByGoodsKind ON tmpGoodsByGoodsKind.GoodsId = MovementItem.ObjectId
                                          AND tmpGoodsByGoodsKind.GoodsKindId = COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
             LEFT JOIN tmpObject_GoodsPropertyValue ON tmpObject_GoodsPropertyValue.GoodsId = MovementItem.ObjectId
                                                   AND tmpObject_GoodsPropertyValue.GoodsKindId = COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                                                   AND tmpObject_GoodsPropertyValue.BarCode <> ''
             LEFT JOIN tmpObject_GoodsPropertyValueGroup ON tmpObject_GoodsPropertyValueGroup.GoodsId = MovementItem.ObjectId
                                                        AND tmpObject_GoodsPropertyValue.GoodsId IS NULL
             LEFT JOIN tmpObject_GoodsPropertyValue_basis ON tmpObject_GoodsPropertyValue_basis.GoodsId = MovementItem.ObjectId
                                                         AND tmpObject_GoodsPropertyValue_basis.GoodsKindId = COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
             LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                  ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                                 AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
             LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId
             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
             LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

        WHERE MovementItem.MovementId = inMovementId
          AND MovementItem.DescId = zc_MI_Master()
          AND MovementItem.isErased = FALSE
          AND MIFloat_AmountPartner.ValueData <> 0
       ;
       
     -- послние строчки XML
     --INSERT INTO _Result(RowData) VALUES ('</head>');
     INSERT INTO _Result(RowData) VALUES ('</root>');


     END IF;
     END IF;
     END IF;


     IF vbExportKindId IN (zc_Enum_ExportKind_Vez37171990(), zc_Enum_ExportKind_Brusn34604386())
     THEN
         -- Результат
         RETURN QUERY
            SELECT STRING_AGG (_Result.RowData, CHR(13)) :: TBlob FROM _Result;
     ELSE
         -- Результат
         RETURN QUERY
            SELECT _Result.RowData FROM _Result;
     END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION gpselect_movement_email_send(integer, tvarchar)
  OWNER TO admin;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 23.03.16                                        *
 25.02.16                                        *
 05.06.16 Допилена выгрузка для Шери - XML формат*
*/

-- тест
-- SELECT * FROM gpSelect_Movement_Email_Send (inMovementId:= 3376510, inSession:= zfCalc_UserAdmin()) -- zc_Enum_ExportKind_Mida35273055()
-- SELECT * FROM gpSelect_Movement_Email_Send (inMovementId:= 3252496, inSession:= zfCalc_UserAdmin()) -- zc_Enum_ExportKind_Vez37171990()
-- SELECT * FROM gpSelect_Movement_Email_Send (inMovementId:= 3438890, inSession:= zfCalc_UserAdmin()) -- zc_Enum_ExportKind_Brusn34604386()
