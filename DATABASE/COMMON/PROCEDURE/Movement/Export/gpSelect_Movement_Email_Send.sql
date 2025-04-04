-- Function: gpSelect_Movement_Email_Send(Integer, tvarchar)

DROP FUNCTION IF EXISTS gpSelect_Movement_Email_Send (Integer, tvarchar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Email_Send(
    IN inMovementId           Integer   ,
    IN inSession              TVarChar    -- сессия пользователя
)
RETURNS TABLE (RowData TBlob)
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbPartnerId Integer;
   DECLARE vbOperDatePartner TDateTime;
   DECLARE vbOperDate        TDateTime;

   DECLARE vbGoodsPropertyId Integer;
   DECLARE vbGoodsPropertyId_basis Integer;
   DECLARE vbExportKindId Integer;

   DECLARE vbPaidKindId Integer;
   DECLARE vbChangePercent TFloat;

   DECLARE vbIsChangePrice Boolean;
   DECLARE vbIsDiscountPrice Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Email_Send());
     vbUserId := lpGetUserBySession (inSession);


     -- Таблица для результата
     CREATE TEMP TABLE _Result (RowData TBlob) ON COMMIT DROP;


     -- параметры из документа
     SELECT tmp.OperDate
          , tmp.OperDatePartner
          , tmp.PartnerId
          , tmp.GoodsPropertyId
          , tmp.GoodsPropertyId_basis
          , tmp.ExportKindId
          , tmp.PaidKindId
          , tmp.ChangePercent
          , tmp.isDiscountPrice_juridical
            INTO vbOperDate, vbOperDatePartner, vbPartnerId, vbGoodsPropertyId, vbGoodsPropertyId_basis, vbExportKindId, vbPaidKindId, vbChangePercent, vbIsDiscountPrice
     FROM (WITH tmpExportJuridical AS (SELECT DISTINCT tmp.PartnerId, tmp.ExportKindId FROM lpSelect_Object_ExportJuridical_list() AS tmp)
                -- Недавній ФОП- формат XLS
              , tmpExport_XLS AS (SELECT DISTINCT tmp.PartnerId, tmp.ExportKindId FROM lpSelect_Object_ExportJuridical_list() AS tmp WHERE tmp.Id = 7448983 LIMIT 1)
           --
           SELECT Movement.OperDate AS OperDate
                , MovementDate_OperDatePartner.ValueData AS OperDatePartner
                , Object_Partner.Id AS PartnerId
                , zfCalc_GoodsPropertyId (MovementLinkObject_Contract.ObjectId, COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, Object_Partner.Id), Object_Partner.Id) AS GoodsPropertyId
                , zfCalc_GoodsPropertyId (0, zc_Juridical_Basis(), 0) AS GoodsPropertyId_basis
                  --
                , COALESCE (tmpExportJuridical.ExportKindId, tmpExport_XLS.ExportKindId) AS ExportKindId
                  --
                , MovementLinkObject_PaidKind.ObjectId AS PaidKindId
                , COALESCE (MovementFloat_ChangePercent.ValueData, 0) AS ChangePercent
                , COALESCE (ObjectBoolean_isDiscountPrice.ValueData, FALSE) AS isDiscountPrice_juridical
           FROM Movement
                LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                       ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                      AND MovementDate_OperDatePartner.DescId     = zc_MovementDate_OperDatePartner()
                LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                        ON MovementFloat_ChangePercent.MovementId = Movement.Id
                                       AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()
                LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                             ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                            AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
                LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                             ON MovementLinkObject_Contract.MovementId = Movement.Id
                                            AND MovementLinkObject_Contract.DescId IN (zc_MovementLinkObject_Contract(), zc_MovementLinkObject_ContractTo())
                LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                             ON MovementLinkObject_From.MovementId = Movement.Id
                                            AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                             ON MovementLinkObject_To.MovementId = Movement.Id
                                            AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = CASE WHEN Movement.DescId = zc_Movement_Sale() THEN MovementLinkObject_To.ObjectId ELSE MovementLinkObject_From.ObjectId END
                LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                     ON ObjectLink_Partner_Juridical.ObjectId = Object_Partner.Id
                                    AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                LEFT JOIN ObjectBoolean AS ObjectBoolean_isDiscountPrice
                                        ON ObjectBoolean_isDiscountPrice.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                       AND ObjectBoolean_isDiscountPrice.DescId = zc_ObjectBoolean_Juridical_isDiscountPrice()
                LEFT JOIN tmpExportJuridical ON tmpExportJuridical.PartnerId = Object_Partner.Id
                LEFT JOIN tmpExport_XLS ON 1=1
           WHERE Movement.Id = inMovementId
          ) AS tmp
    ;


     -- !!!надо определить - есть ли скидка в цене!!!
     vbIsChangePrice:= vbIsDiscountPrice = TRUE                              -- у Юр лица есть галка
                    OR vbPaidKindId = zc_Enum_PaidKind_FirstForm()           -- это БН
                    OR (vbChangePercent <> 0                                 -- в шапке есть скидка, но есть хоть один элемент со скидкой = 0%
                        AND EXISTS (SELECT 1
                                    FROM MovementItem
                                         LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                                                     ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                                                    AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()
                                    WHERE MovementItem.MovementId = inMovementId
                                      AND MovementItem.DescId = zc_MI_Master()
                                      AND MovementItem.isErased = FALSE
                                      AND COALESCE (MIFloat_ChangePercent.ValueData, 0) = 0
                                   ));


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
             LEFT JOIN ObjectString AS ObjectString_RoomNumber
                                    ON ObjectString_RoomNumber.ObjectId = vbPartnerId
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
     || ';' || CASE WHEN Movement.DescId = zc_Movement_Sale() THEN 'RN' ELSE 'VN' END -- Вид документа : RN – расходная накладная or VN – возвратная накладная or SP - спецификация
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

             LEFT JOIN ObjectString AS ObjectString_GLNCode
                                    ON ObjectString_GLNCode.ObjectId = vbPartnerId
                                   AND ObjectString_GLNCode.DescId = zc_ObjectString_Partner_GLNCode()
             LEFT JOIN ObjectString AS ObjectString_RoomNumber
                                    ON ObjectString_RoomNumber.ObjectId = vbPartnerId
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
     INSERT INTO _Result(RowData) VALUES ('<?xml version="1.0" encoding="UTF-16"?>');
     INSERT INTO _Result(RowData) VALUES ('<root>');
     INSERT INTO _Result(RowData) VALUES ('<Export Provider="9990074" />');

     -- Строчная часть
     INSERT INTO _Result(RowData)
        WITH tmpMovement AS
                (SELECT Movement.Id                                      AS MovementId
                      , Movement.InvNumber                               AS InvNumber
                      , MovementDate_OperDatePartner.ValueData           AS OperDatePartner
                      , vbPartnerId                                      AS PartnerId
                      , COALESCE (Object_To.ValueData, '')               AS PartnerName
                      , COALESCE (ObjectString_GLNCode.ValueData, '')    AS GLNCode
                      , COALESCE (ObjectString_RoomNumber.ValueData, '') AS RoomNumber
                 FROM Movement
                      LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                             ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                            AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

                      LEFT JOIN Object AS Object_To ON Object_To.Id = vbPartnerId
                      LEFT JOIN ObjectString AS ObjectString_GLNCode
                                             ON ObjectString_GLNCode.ObjectId = vbPartnerId
                                            AND ObjectString_GLNCode.DescId = zc_ObjectString_Partner_GLNCode()
                      LEFT JOIN ObjectString AS ObjectString_RoomNumber
                                             ON ObjectString_RoomNumber.ObjectId = vbPartnerId
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
     || '" CEN="' || CAST (1.2 * CASE WHEN MIFloat_ChangePercent.ValueData <> 0 AND vbIsChangePrice = TRUE
                                           THEN zfCalc_PriceTruncate (inOperDate     := vbOperDatePartner
                                                                    , inChangePercent:= MIFloat_ChangePercent.ValueData
                                                                    , inPrice        := CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData ELSE MIFloat_Price.ValueData END
                                                                    , inIsWithVAT    := FALSE
                                                                     )
                                      WHEN vbChangePercent <> 0 AND vbIsChangePrice = FALSE
                                           THEN zfCalc_PriceTruncate (inOperDate     := vbOperDatePartner
                                                                    , inChangePercent:= vbChangePercent
                                                                    , inPrice        := CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData ELSE MIFloat_Price.ValueData END
                                                                    , inIsWithVAT    := FALSE
                                                                     )
                                      ELSE CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData ELSE MIFloat_Price.ValueData END
                                 END
                           AS NUMERIC(16, 2)) :: TVarChar
               -- имя товара на всяк случай если забыли сообщить штрихкод
     || '" NAM="' || REPLACE (Object_Goods.ValueData, '"', '') || CASE WHEN COALESCE (MILinkObject_GoodsKind.ObjectId, zc_Enum_GoodsKind_Main()) = zc_Enum_GoodsKind_Main() THEN '' ELSE ' ' || Object_GoodsKind.ValueData END
               -- магазин (мы номер магаза по нашей кодификации или ваша кака-нить уникальность ТТ)
     || '" MAG="' || tmpMovement.PartnerId -- tmpMovement.RoomNumber
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
             LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                         ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                        AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()
             LEFT JOIN MovementItemFloat AS MIFloat_Price
                                         ON MIFloat_Price.MovementItemId = MovementItem.Id
                                        AND MIFloat_Price.DescId = zc_MIFloat_Price()
             LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                         ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                        AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
             LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                         ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                        AND MIFloat_Summ.DescId = zc_MIFloat_Summ()
             LEFT JOIN MovementItemFloat AS MIFloat_Discount
                                         ON MIFloat_Discount.MovementItemId = MovementItem.Id
                                        AND MIFloat_Discount.DescId = zc_MIFloat_ChangePercent()
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
     -- последние строчки XML
     INSERT INTO _Result(RowData) VALUES ('</root>');

     ELSE

     -- !!!4.Формат CSV - zc_Enum_ExportKind_Dakort39135074!!!

     IF vbExportKindId = zc_Enum_ExportKind_Dakort39135074()
     THEN


     -- первая строчка CSV  - Шапка
     INSERT INTO _Result(RowData)
        SELECT COALESCE (Object_JuridicalBasis.ValueData, 'Alan')
        -- Код ОКПО
	|| ';' || COALESCE (OH_JuridicalDetails_From.OKPO, '')
	--Номер РН
	|| ';' || Movement.InvNumber

	-- Адрес доставки (в ObjectString_RoomNumber.ValueData хранится номер магазина)
	--|| ';' || 'DP:V'||ObjectString_RoomNumber.ValueData||' - НЕКТАР №'||ObjectString_RoomNumber.ValueData||' '||COALESCE(Object_PartnerAdress.ValueData, '')
	|| ';' || CASE WHEN View_Contract.JuridicalId = 11978558 -- Деметра Рітейл ТОВ
                            THEN 'V'
                       ELSE 'DP:V'
                  END
                || COALESCE (ObjectString_ShortName.ValueData, '')
              --|| CASE WHEN vbUserId = 5
              --             THEN '*' || COALESCE (View_Contract.JuridicalId, 0)  :: TVarChar
              --        ELSE ''
              --    END

	-- Версия формата
	|| ';' || '14'
	-- Вид документа : RN – расходная накладная or VN – возвратная накладная or SP - спецификация
	|| ';' || CASE WHEN Movement.DescId = zc_Movement_Sale() THEN 'RN' ELSE 'VN' END
	-- Дата РН
	|| ';' || zfConvert_DateToString (MovementDate_OperDatePartner.ValueData)
	-- Номер договора
	|| ';' || COALESCE (View_Contract.InvNumber, '')
	-- Форма накладной
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
             LEFT JOIN Object AS Object_PartnerAdress
                              ON Object_PartnerAdress.Id = vbPartnerId
                             AND Object_PartnerAdress.DescId = zc_Object_Partner()
             LEFT JOIN ObjectString AS ObjectString_RoomNumber
                                    ON ObjectString_RoomNumber.ObjectId = vbPartnerId
                                   AND ObjectString_RoomNumber.DescId = zc_ObjectString_Partner_RoomNumber()

             LEFT JOIN ObjectString AS ObjectString_ShortName
                                    ON ObjectString_ShortName.ObjectId = vbPartnerId
                                   AND ObjectString_ShortName.DescId = zc_ObjectString_Partner_ShortName()

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
        SELECT --*** Штрих-код
               --*** COALESCE (tmpObject_GoodsPropertyValue.BarCode, COALESCE (tmpObject_GoodsPropertyValueGroup.BarCode, COALESCE (tmpObject_GoodsPropertyValue.BarCode, '')))
               -- Внутренний код - справочник - "Параметры Товар и вид товара"
               tmpGoodsByGoodsKind.ObjectId :: TVarChar
               -- Кол-во
     || ';' || (MIFloat_AmountPartner.ValueData :: NUMERIC (16, 3)) :: TVarChar
               -- Цена с НДС
     || ';' || CAST (CASE WHEN MIFloat_ChangePercent.ValueData <> 0 AND vbIsChangePrice = TRUE
                               THEN zfCalc_PriceTruncate (inOperDate     := vbOperDatePartner
                                                        , inChangePercent:= MIFloat_ChangePercent.ValueData
                                                        , inPrice        := CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData ELSE MIFloat_Price.ValueData END
                                                        , inIsWithVAT    := FALSE
                                                         )
                          WHEN vbChangePercent <> 0 AND vbIsChangePrice = FALSE
                               THEN zfCalc_PriceTruncate (inOperDate     := vbOperDatePartner
                                                        , inChangePercent:= vbChangePercent
                                                        , inPrice        := CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData ELSE MIFloat_Price.ValueData END
                                                        , inIsWithVAT    := FALSE
                                                         )
                          ELSE CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData ELSE MIFloat_Price.ValueData END
                     END
                   * 1.2
               AS NUMERIC (16, 3)) :: TVarChar
     || ';' || REPLACE (Object_Goods.ValueData, '"', '') || CASE WHEN COALESCE (MILinkObject_GoodsKind.ObjectId, zc_Enum_GoodsKind_Main()) = zc_Enum_GoodsKind_Main() THEN '' ELSE ' ' || Object_GoodsKind.ValueData END
     || ';1' -- Коэффициент
     || ';' || COALESCE (Object_Measure.ValueData, '')
               -- Цена без НДС
     || ';' || CAST (CASE WHEN MIFloat_ChangePercent.ValueData <> 0 AND vbIsChangePrice = TRUE
                               THEN zfCalc_PriceTruncate (inOperDate     := vbOperDatePartner
                                                        , inChangePercent:= MIFloat_ChangePercent.ValueData
                                                        , inPrice        := CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData ELSE MIFloat_Price.ValueData END
                                                        , inIsWithVAT    := FALSE
                                                         )
                          WHEN vbChangePercent <> 0 AND vbIsChangePrice = FALSE
                               THEN zfCalc_PriceTruncate (inOperDate     := vbOperDatePartner
                                                        , inChangePercent:= vbChangePercent
                                                        , inPrice        := CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData ELSE MIFloat_Price.ValueData END
                                                        , inIsWithVAT    := FALSE
                                                         )
                          ELSE CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData ELSE MIFloat_Price.ValueData END
                     END
               AS NUMERIC (16, 3)) :: TVarChar
               -- Сумма без НДС
     || ';' || CAST
              (CAST (CASE WHEN MIFloat_ChangePercent.ValueData <> 0 AND vbIsChangePrice = TRUE
                               THEN zfCalc_PriceTruncate (inOperDate     := vbOperDatePartner
                                                        , inChangePercent:= MIFloat_ChangePercent.ValueData
                                                        , inPrice        := CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData ELSE MIFloat_Price.ValueData END
                                                        , inIsWithVAT    := FALSE
                                                         )
                          WHEN vbChangePercent <> 0 AND vbIsChangePrice = FALSE
                               THEN zfCalc_PriceTruncate (inOperDate     := vbOperDatePartner
                                                        , inChangePercent:= vbChangePercent
                                                        , inPrice        := CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData ELSE MIFloat_Price.ValueData END
                                                        , inIsWithVAT    := FALSE
                                                         )
                          ELSE CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData ELSE MIFloat_Price.ValueData END
                     END
               AS NUMERIC (16, 3))
             * MIFloat_AmountPartner.ValueData AS NUMERIC (16, 2)) :: TVarChar
               -- Сумма с НДС
     || ';' || CAST
              (CAST (CASE WHEN MIFloat_ChangePercent.ValueData <> 0 AND vbIsChangePrice = TRUE
                               THEN zfCalc_PriceTruncate (inOperDate     := vbOperDatePartner
                                                        , inChangePercent:= MIFloat_ChangePercent.ValueData
                                                        , inPrice        := CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData ELSE MIFloat_Price.ValueData END
                                                        , inIsWithVAT    := FALSE
                                                         )
                          WHEN vbChangePercent <> 0 AND vbIsChangePrice = FALSE
                               THEN zfCalc_PriceTruncate (inOperDate     := vbOperDatePartner
                                                        , inChangePercent:= vbChangePercent
                                                        , inPrice        := CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData ELSE MIFloat_Price.ValueData END
                                                        , inIsWithVAT    := FALSE
                                                         )
                          ELSE CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData ELSE MIFloat_Price.ValueData END
                     END
                   * 1.2
               AS NUMERIC (16, 3))
             * MIFloat_AmountPartner.ValueData AS NUMERIC (16, 2)) :: TVarChar
               -- НДС
    || ';' || (CAST
              (CAST (CASE WHEN MIFloat_ChangePercent.ValueData <> 0 AND vbIsChangePrice = TRUE
                               THEN zfCalc_PriceTruncate (inOperDate     := vbOperDatePartner
                                                        , inChangePercent:= MIFloat_ChangePercent.ValueData
                                                        , inPrice        := CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData ELSE MIFloat_Price.ValueData END
                                                        , inIsWithVAT    := FALSE
                                                         )
                          WHEN vbChangePercent <> 0 AND vbIsChangePrice = FALSE
                               THEN zfCalc_PriceTruncate (inOperDate     := vbOperDatePartner
                                                        , inChangePercent:= vbChangePercent
                                                        , inPrice        := CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData ELSE MIFloat_Price.ValueData END
                                                        , inIsWithVAT    := FALSE
                                                         )
                          ELSE CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData ELSE MIFloat_Price.ValueData END
                     END
                   * 1.2
               AS NUMERIC (16, 3))
             * MIFloat_AmountPartner.ValueData AS NUMERIC (16, 2))
             - CAST
              (CAST (CASE WHEN MIFloat_ChangePercent.ValueData <> 0 AND vbIsChangePrice = TRUE
                               THEN zfCalc_PriceTruncate (inOperDate     := vbOperDatePartner
                                                        , inChangePercent:= MIFloat_ChangePercent.ValueData
                                                        , inPrice        := CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData ELSE MIFloat_Price.ValueData END
                                                        , inIsWithVAT    := FALSE
                                                         )
                          WHEN vbChangePercent <> 0 AND vbIsChangePrice = FALSE
                               THEN zfCalc_PriceTruncate (inOperDate     := vbOperDatePartner
                                                        , inChangePercent:= vbChangePercent
                                                        , inPrice        := CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData ELSE MIFloat_Price.ValueData END
                                                        , inIsWithVAT    := FALSE
                                                         )
                          ELSE CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData ELSE MIFloat_Price.ValueData END
                     END
               AS NUMERIC (16, 3))
             * MIFloat_AmountPartner.ValueData AS NUMERIC (16, 2))
              ) :: TVarChar
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
             LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                         ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                        AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()
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

     -- !!!5.Формат XML - zc_Enum_ExportKind_Glad2514900150!!!

     IF vbExportKindId = zc_Enum_ExportKind_Glad2514900150()
     THEN

     -- первые строчки XML
     -- INSERT INTO _Result(RowData) VALUES ('<?xml version="1.0" encoding="windows-1251"?>');
     INSERT INTO _Result(RowData) VALUES ('<?xml version="1.0" encoding="UTF-8"?>');
     INSERT INTO _Result(RowData) VALUES ('<DATA>');

     -- Шапка
     INSERT INTO _Result(RowData)
        SELECT '<Stock DistCode="1024"'                                                                             -- Код поставщика, предоставляется нами.
                  ||    ' DistName="' || REPLACE (COALESCE (OH_JuridicalDetails_From.FullName, ''), '"', '') ||'"'  -- название поставщика
                  ||    ' StockCode="' || COALESCE (ObjectString_RoomNumber.ValueData, '') ||'"'                    -- код Магазина/Маркета/Склада, на который осуществляется доставка – предоставляется нами.
                  ||    ' StockName="' || REPLACE (COALESCE (Object_To.ValueData, ''), '"', '') ||'">'              -- название магазина/склада.

                  || ' <DOCUMENTS>'

                  || ' <DOCUMENT'
                  || ' Name="Delivery"'
                  || ' Number="' || Movement.InvNumber ||'"'
                  || ' Date="' || zfConvert_DateToStringY (MovementDate_OperDatePartner.ValueData) ||'"'
                  || CASE WHEN Movement_Master.Id > 0 AND MLO_PaidKind.ObjectId = zc_Enum_PaidKind_FirstForm()
                               THEN ' TaxNum ="' || COALESCE (MS_InvNumberPartner_Master.ValueData, '') ||'"'
                                 || ' TaxDate="' || zfConvert_DateToStringY (Movement_Master.OperDate) ||'"'
                               ELSE ' TaxNum ="0"'
                                 || ' TaxDate=""'
                     END
                  ||  ' Type="' || CASE WHEN MLO_PaidKind.ObjectId = zc_Enum_PaidKind_FirstForm() THEN '1' ELSE '0' END ||'">' -- тип учета.(Бухгалтерский - 1, Управленческий - 0)
        FROM Movement
             LEFT JOIN MovementString AS MovementString_InvNumberOrder
                                      ON MovementString_InvNumberOrder.MovementId =  Movement.Id
                                     AND MovementString_InvNumberOrder.DescId     = zc_MovementString_InvNumberOrder()
             LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                    ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                   AND MovementDate_OperDatePartner.DescId     = zc_MovementDate_OperDatePartner()
             LEFT JOIN MovementLinkObject AS MLO_From
                                          ON MLO_From.MovementId = Movement.Id
                                         AND MLO_From.DescId     = zc_MovementLinkObject_From()
             LEFT JOIN MovementLinkObject AS MLO_PaidKind
                                          ON MLO_PaidKind.MovementId = Movement.Id
                                         AND MLO_PaidKind.DescId     = zc_MovementLinkObject_PaidKind()
             LEFT JOIN MovementLinkObject AS MLO_Contract
                                          ON MLO_Contract.MovementId = Movement.Id
                                         AND MLO_Contract.DescId     = zc_MovementLinkObject_Contract()
             LEFT JOIN Object_Contract_View AS View_Contract ON View_Contract.ContractId = MLO_Contract.ObjectId
             LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalDocument
                                  ON ObjectLink_Contract_JuridicalDocument.ObjectId = MLO_Contract.ObjectId
                                 AND ObjectLink_Contract_JuridicalDocument.DescId   = zc_ObjectLink_Contract_JuridicalDocument()
                                 AND MLO_PaidKind.ObjectId                          = zc_Enum_PaidKind_SecondForm()
             LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                  ON ObjectLink_Unit_Juridical.ObjectId  = MLO_From.ObjectId
                                 AND ObjectLink_Unit_Juridical.DescId    = zc_ObjectLink_Unit_Juridical()
                                 AND COALESCE (MLO_Contract.ObjectId, 0) = 0
             LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetails_From
                                                                 ON OH_JuridicalDetails_From.JuridicalId = COALESCE (ObjectLink_Contract_JuridicalDocument.ChildObjectId
                                                                                                         , COALESCE (View_Contract.JuridicalBasisId
                                                                                                         , COALESCE (ObjectLink_Unit_Juridical.ChildObjectId
                                                                                                                   , MLO_From.ObjectId)))
                                                                AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) >= OH_JuridicalDetails_From.StartDate
                                                                AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) <  OH_JuridicalDetails_From.EndDate
             LEFT JOIN Object AS Object_To ON Object_To.Id = vbPartnerId
             LEFT JOIN ObjectString AS ObjectString_RoomNumber
                                    ON ObjectString_RoomNumber.ObjectId = vbPartnerId
                                   AND ObjectString_RoomNumber.DescId   = zc_ObjectString_Partner_RoomNumber()
             LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Master
                                            ON MovementLinkMovement_Master.MovementId = Movement.Id
                                           AND MovementLinkMovement_Master.DescId     = zc_MovementLinkMovement_Master()
             LEFT JOIN Movement AS Movement_Master ON Movement_Master.Id = MovementLinkMovement_Master.MovementChildId
             LEFT JOIN MovementString AS MS_InvNumberPartner_Master ON MS_InvNumberPartner_Master.MovementId = MovementLinkMovement_Master.MovementChildId
                                                                   AND MS_InvNumberPartner_Master.DescId     = zc_MovementString_InvNumberPartner()
        WHERE Movement.Id = inMovementId
       ;

     -- Строчная часть
     INSERT INTO _Result(RowData) VALUES ('<TABLE>');

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
                (SELECT tmpObject_GoodsPropertyValue.ObjectId
                      , tmpObject_GoodsPropertyValue.GoodsId
                      , tmpObject_GoodsPropertyValue.BarCode
                      , tmpObject_GoodsPropertyValue.Article
                 FROM (SELECT MAX (tmpObject_GoodsPropertyValue.ObjectId) AS ObjectId, GoodsId FROM tmpObject_GoodsPropertyValue WHERE Article <> '' GROUP BY GoodsId
                      ) AS tmpGoodsProperty_find
                      LEFT JOIN tmpObject_GoodsPropertyValue ON tmpObject_GoodsPropertyValue.ObjectId =  tmpGoodsProperty_find.ObjectId
                )
           , tmpObject_GoodsPropertyValue_basis AS
                (SELECT ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                      , ObjectLink_GoodsPropertyValue_Goods.ChildObjectId AS GoodsId
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
             --'<ITEM Code="' || COALESCE (tmpObject_GoodsPropertyValue.Article, COALESCE (tmpObject_GoodsPropertyValueGroup.Article, COALESCE (tmpObject_GoodsPropertyValue_basis.Article, ''))) || '"'
               '<ITEM Code="' || COALESCE (Object_GoodsByGoodsKind_View.Id, COALESCE (tmpObject_GoodsPropertyValue.ObjectId, COALESCE (tmpObject_GoodsPropertyValueGroup.ObjectId, COALESCE (tmpObject_GoodsPropertyValue_basis.ObjectId, 0)))) :: TVarChar|| '"'
               || ' Name="' || REPLACE (Object_Goods.ValueData, '"', '') || CASE WHEN COALESCE (MILinkObject_GoodsKind.ObjectId, zc_Enum_GoodsKind_Main()) = zc_Enum_GoodsKind_Main() THEN '' ELSE ' ' || Object_GoodsKind.ValueData END || '"'
               || ' Num="' || (MIFloat_AmountPartner.ValueData :: NUMERIC (16, 3)) :: TVarChar || '"'
               || ' Price="' || CASE WHEN MIFloat_CountForPrice.ValueData > 1 THEN CAST (MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 3)) :: TVarChar ELSE CAST (MIFloat_Price.ValueData AS NUMERIC (16, 3)) :: TVarChar END || '"'
             --|| ' BarCode=""'
               || CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ' Weight="' || ObjectFloat_Weight.ValueData :: TVarChar || '"' ELSE '' END
               || ' IsWeight="' || CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN '0' ELSE '1' END || '"'
               || ' Unit="' || CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN '1' ELSE '2' END || '"'
             --|| ' NumInBox=""' 
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
                                                   -- AND tmpObject_GoodsPropertyValue.Article <> ''
             LEFT JOIN tmpObject_GoodsPropertyValueGroup ON tmpObject_GoodsPropertyValueGroup.GoodsId = MovementItem.ObjectId
                                                        AND tmpObject_GoodsPropertyValue.GoodsId IS NULL
             LEFT JOIN tmpObject_GoodsPropertyValue_basis ON tmpObject_GoodsPropertyValue_basis.GoodsId = MovementItem.ObjectId
                                                         AND tmpObject_GoodsPropertyValue_basis.GoodsKindId = COALESCE (MILinkObject_GoodsKind.ObjectId, 0)

             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
             LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

             LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                   ON ObjectFloat_Weight.ObjectId = Object_Goods.Id
                                  AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
             LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                  ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_Measure.DescId   = zc_ObjectLink_Goods_Measure()
             LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

             LEFT JOIN Object_GoodsByGoodsKind_View ON Object_GoodsByGoodsKind_View.GoodsId     = Object_Goods.Id
                                                   AND Object_GoodsByGoodsKind_View.GoodsKindId = Object_GoodsKind.Id

        WHERE MovementItem.MovementId = inMovementId
          AND MovementItem.DescId = zc_MI_Master()
          AND MovementItem.isErased = FALSE
          AND MIFloat_AmountPartner.ValueData <> 0
       ORDER BY Object_Goods.ValueData, Object_GoodsKind.ValueData
       ;

     -- последние строчки XML
     INSERT INTO _Result(RowData) VALUES ('</TABLE>');
     INSERT INTO _Result(RowData) VALUES ('</DOCUMENT>');
     INSERT INTO _Result(RowData) VALUES ('</DOCUMENTS>');
     INSERT INTO _Result(RowData) VALUES ('</Stock>');
     INSERT INTO _Result(RowData) VALUES ('</DATA>');
    
     ELSE


     -- !!!6.Формат CSV - zc_Enum_ExportKind_Avion40110917!!!

     IF vbExportKindId = zc_Enum_ExportKind_Avion40110917()
     THEN

     -- первая строчка CSV  - Шапка
     INSERT INTO _Result(RowData)
        SELECT COALESCE (Object_JuridicalBasis.ValueData, 'Alan')
        -- Код ОКПО
	|| ';' || COALESCE (OH_JuridicalDetails_From.OKPO, '')
	--Номер РН
	|| ';' || Movement.InvNumber
	-- Адрес доставки: Позначення регіону:KH – Херсон DN – Дніпро KV – Київ ZD – Захід + VНомер магазину
	|| ';' || 'KH:V749'
	-- Версия формата
	|| ';' || '14'
	-- Вид документа : RN – расходная накладная or VN – возвратная накладная or SP - спецификация
	|| ';' || CASE WHEN Movement.DescId = zc_Movement_Sale() THEN 'RN' ELSE 'VN' END
	-- Дата РН   --ДД.ММ.РРРР
	|| ';' || zfConvert_DateToString (MovementDate_OperDatePartner.ValueData)           
	-- Номер договора
	|| ';' || COALESCE (View_Contract.InvNumber, '')
	-- Форма накладной
	|| ';' || CASE WHEN MovementLinkObject_PaidKind.ObjectId = zc_Enum_PaidKind_FirstForm() THEN '10' ELSE '11' END
	-- Код складу, куди здійснюється доставка - 1 – товарний РЦ Некрасова 2 * 16 - сигарети РЦ Некрасова 2 * 15 – СВЗ** Некрасова 2 * 2 - РЦ Первомайськ * 17 – СВЗ** Первомайськ
	|| ';' || COALESCE (ObjectString_RoomNumber.ValueData, '')
        || ';'
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
             LEFT JOIN Object AS Object_PartnerAdress
                              ON Object_PartnerAdress.Id = vbPartnerId
                             AND Object_PartnerAdress.DescId = zc_Object_Partner()
             LEFT JOIN ObjectString AS ObjectString_RoomNumber
                                    ON ObjectString_RoomNumber.ObjectId = vbPartnerId
                                   AND ObjectString_RoomNumber.DescId = zc_ObjectString_Partner_RoomNumber()

             LEFT JOIN ObjectString AS ObjectString_ShortName
                                    ON ObjectString_ShortName.ObjectId = vbPartnerId
                                   AND ObjectString_ShortName.DescId = zc_ObjectString_Partner_ShortName()

        WHERE Movement.Id = inMovementId
       ;

     -- Строчная часть
     INSERT INTO _Result(RowData)
        WITH tmpObject_GoodsPropertyValue AS
                (SELECT ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                      , ObjectLink_GoodsPropertyValue_Goods.ChildObjectId                   AS GoodsId
                      , COALESCE (ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId, 0) AS GoodsKindId
                      , ObjectString_BarCode.ValueData       AS BarCode
                      , ObjectString_Article.ValueData       AS Article
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
                      LEFT JOIN ObjectString AS ObjectString_Article
                                             ON ObjectString_Article.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                            AND ObjectString_Article.DescId = zc_ObjectString_GoodsPropertyValue_Article()
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
                      , ObjectString_BarCode.ValueData       AS BarCode
                      , ObjectString_Article.ValueData       AS Article
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

           , tmpStickerProperty AS
                (SELECT ObjectLink_Sticker_Goods.ChildObjectId                AS GoodsId
                      , ObjectLink_StickerProperty_GoodsKind.ChildObjectId    AS GoodsKindId
                      , COALESCE (ObjectFloat_Value5.ValueData, 0) :: Integer AS Value5
                        --  № п/п
                      , ROW_NUMBER() OVER (PARTITION BY ObjectLink_Sticker_Goods.ChildObjectId, ObjectLink_StickerProperty_GoodsKind.ChildObjectId ORDER BY COALESCE (ObjectFloat_Value5.ValueData, 0) DESC) AS Ord
                 FROM Object AS Object_StickerProperty
                       LEFT JOIN ObjectLink AS ObjectLink_StickerProperty_Sticker
                                            ON ObjectLink_StickerProperty_Sticker.ObjectId = Object_StickerProperty.Id
                                           AND ObjectLink_StickerProperty_Sticker.DescId   = zc_ObjectLink_StickerProperty_Sticker()
                       LEFT JOIN ObjectLink AS ObjectLink_Sticker_Goods
                                            ON ObjectLink_Sticker_Goods.ObjectId = ObjectLink_StickerProperty_Sticker.ChildObjectId
                                           AND ObjectLink_Sticker_Goods.DescId   = zc_ObjectLink_Sticker_Goods()
                       LEFT JOIN ObjectLink AS ObjectLink_Sticker_Juridical
                                            ON ObjectLink_Sticker_Juridical.ObjectId = ObjectLink_StickerProperty_Sticker.ChildObjectId
                                           AND ObjectLink_Sticker_Juridical.DescId   = zc_ObjectLink_StickerProperty_GoodsKind()

                       LEFT JOIN ObjectLink AS ObjectLink_StickerProperty_GoodsKind
                                            ON ObjectLink_StickerProperty_GoodsKind.ObjectId = Object_StickerProperty.Id
                                           AND ObjectLink_StickerProperty_GoodsKind.DescId = zc_ObjectLink_StickerProperty_GoodsKind()

                       LEFT JOIN ObjectFloat AS ObjectFloat_Value5
                                             ON ObjectFloat_Value5.ObjectId = Object_StickerProperty.Id
                                            AND ObjectFloat_Value5.DescId = zc_ObjectFloat_StickerProperty_Value5()
                 WHERE Object_StickerProperty.DescId   = zc_Object_StickerProperty()
                   AND Object_StickerProperty.isErased = FALSE
                   AND ObjectLink_Sticker_Juridical.ChildObjectId IS NULL -- !!! БЕЗ Покупателя!!!
                )
                             
        -- результат
        SELECT --*** Артикул
               Object_Goods.ObjectCode :: TVarChar
             --COALESCE (tmpObject_GoodsPropertyValue.Article, tmpObject_GoodsPropertyValueGroup.Article, tmpObject_GoodsPropertyValue_basis.Article, '')
               -- Внутренний код - справочник - "Параметры Товар и вид товара"
               --tmpGoodsByGoodsKind.ObjectId :: TVarChar
               -- Кол-во
     || ';' || (MIFloat_AmountPartner.ValueData :: NUMERIC (16, 3)) :: TVarChar
               -- Цена с НДС
     || ';' || CAST (CASE WHEN MIFloat_ChangePercent.ValueData <> 0 AND vbIsChangePrice = TRUE
                               THEN zfCalc_PriceTruncate (inOperDate     := vbOperDatePartner
                                                        , inChangePercent:= MIFloat_ChangePercent.ValueData
                                                        , inPrice        := CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData ELSE MIFloat_Price.ValueData END
                                                        , inIsWithVAT    := FALSE
                                                         )
                          WHEN vbChangePercent <> 0 AND vbIsChangePrice = FALSE
                               THEN zfCalc_PriceTruncate (inOperDate     := vbOperDatePartner
                                                        , inChangePercent:= vbChangePercent
                                                        , inPrice        := CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData ELSE MIFloat_Price.ValueData END
                                                        , inIsWithVAT    := FALSE
                                                         )
                          ELSE CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData ELSE MIFloat_Price.ValueData END
                     END
                   * 1.2
               AS NUMERIC (16, 3)) :: TVarChar
               -- Найменування товару
     || ';' || REPLACE (Object_Goods.ValueData, '"', '') || CASE WHEN COALESCE (MILinkObject_GoodsKind.ObjectId, zc_Enum_GoodsKind_Main()) = zc_Enum_GoodsKind_Main() THEN '' ELSE ' ' || Object_GoodsKind.ValueData END
     || ';1' -- Коэффициент
             -- Одиниця виміру
     || ';' || COALESCE (Object_Measure.ValueData, '')
               -- Цена без НДС
     || ';' || CAST (CASE WHEN MIFloat_ChangePercent.ValueData <> 0 AND vbIsChangePrice = TRUE
                               THEN zfCalc_PriceTruncate (inOperDate     := vbOperDatePartner
                                                        , inChangePercent:= MIFloat_ChangePercent.ValueData
                                                        , inPrice        := CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData ELSE MIFloat_Price.ValueData END
                                                        , inIsWithVAT    := FALSE
                                                         )
                          WHEN vbChangePercent <> 0 AND vbIsChangePrice = FALSE
                               THEN zfCalc_PriceTruncate (inOperDate     := vbOperDatePartner
                                                        , inChangePercent:= vbChangePercent
                                                        , inPrice        := CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData ELSE MIFloat_Price.ValueData END
                                                        , inIsWithVAT    := FALSE
                                                         )
                          ELSE CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData ELSE MIFloat_Price.ValueData END
                     END
               AS NUMERIC (16, 3)) :: TVarChar
               -- Сумма без НДС
     || ';' || CAST
              (CAST (CASE WHEN MIFloat_ChangePercent.ValueData <> 0 AND vbIsChangePrice = TRUE
                               THEN zfCalc_PriceTruncate (inOperDate     := vbOperDatePartner
                                                        , inChangePercent:= MIFloat_ChangePercent.ValueData
                                                        , inPrice        := CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData ELSE MIFloat_Price.ValueData END
                                                        , inIsWithVAT    := FALSE
                                                         )
                          WHEN vbChangePercent <> 0 AND vbIsChangePrice = FALSE
                               THEN zfCalc_PriceTruncate (inOperDate     := vbOperDatePartner
                                                        , inChangePercent:= vbChangePercent
                                                        , inPrice        := CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData ELSE MIFloat_Price.ValueData END
                                                        , inIsWithVAT    := FALSE
                                                         )
                          ELSE CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData ELSE MIFloat_Price.ValueData END
                     END
               AS NUMERIC (16, 3))
             * MIFloat_AmountPartner.ValueData AS NUMERIC (16, 2)) :: TVarChar
               -- Сумма с НДС
     || ';' || CAST
              (CAST (CASE WHEN MIFloat_ChangePercent.ValueData <> 0 AND vbIsChangePrice = TRUE
                               THEN zfCalc_PriceTruncate (inOperDate     := vbOperDatePartner
                                                        , inChangePercent:= MIFloat_ChangePercent.ValueData
                                                        , inPrice        := CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData ELSE MIFloat_Price.ValueData END
                                                        , inIsWithVAT    := FALSE
                                                         )
                          WHEN vbChangePercent <> 0 AND vbIsChangePrice = FALSE
                               THEN zfCalc_PriceTruncate (inOperDate     := vbOperDatePartner
                                                        , inChangePercent:= vbChangePercent
                                                        , inPrice        := CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData ELSE MIFloat_Price.ValueData END
                                                        , inIsWithVAT    := FALSE
                                                         )
                          ELSE CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData ELSE MIFloat_Price.ValueData END
                     END
                   * 1.2
               AS NUMERIC (16, 3))
             * MIFloat_AmountPartner.ValueData AS NUMERIC (16, 2)) :: TVarChar
               -- НДС
    || ';' || (CAST
              (CAST (CASE WHEN MIFloat_ChangePercent.ValueData <> 0 AND vbIsChangePrice = TRUE
                               THEN zfCalc_PriceTruncate (inOperDate     := vbOperDatePartner
                                                        , inChangePercent:= MIFloat_ChangePercent.ValueData
                                                        , inPrice        := CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData ELSE MIFloat_Price.ValueData END
                                                        , inIsWithVAT    := FALSE
                                                         )
                          WHEN vbChangePercent <> 0 AND vbIsChangePrice = FALSE
                               THEN zfCalc_PriceTruncate (inOperDate     := vbOperDatePartner
                                                        , inChangePercent:= vbChangePercent
                                                        , inPrice        := CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData ELSE MIFloat_Price.ValueData END
                                                        , inIsWithVAT    := FALSE
                                                         )
                          ELSE CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData ELSE MIFloat_Price.ValueData END
                     END
                   * 1.2
               AS NUMERIC (16, 3))
             * MIFloat_AmountPartner.ValueData AS NUMERIC (16, 2))
             - CAST
              (CAST (CASE WHEN MIFloat_ChangePercent.ValueData <> 0 AND vbIsChangePrice = TRUE
                               THEN zfCalc_PriceTruncate (inOperDate     := vbOperDatePartner
                                                        , inChangePercent:= MIFloat_ChangePercent.ValueData
                                                        , inPrice        := CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData ELSE MIFloat_Price.ValueData END
                                                        , inIsWithVAT    := FALSE
                                                         )
                          WHEN vbChangePercent <> 0 AND vbIsChangePrice = FALSE
                               THEN zfCalc_PriceTruncate (inOperDate     := vbOperDatePartner
                                                        , inChangePercent:= vbChangePercent
                                                        , inPrice        := CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData ELSE MIFloat_Price.ValueData END
                                                        , inIsWithVAT    := FALSE
                                                         )
                          ELSE CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData ELSE MIFloat_Price.ValueData END
                     END
               AS NUMERIC (16, 3))
             * MIFloat_AmountPartner.ValueData AS NUMERIC (16, 2))
              ) :: TVarChar

               --*** штрихкод
    || ';' || COALESCE (tmpObject_GoodsPropertyValue.BarCode, tmpObject_GoodsPropertyValueGroup.BarCode, tmpObject_GoodsPropertyValue_basis.BarCode, '')
               --*** МРЦ
    || ';' 
               -- Термін придатності
    || ';' || CASE WHEN COALESCE (tmpStickerProperty.Value5,0) <> 0 THEN tmpStickerProperty.Value5 :: TVarChar ELSE '' END :: TVarChar
               -- Дата виробництва
    || ';' ||  CASE WHEN MIDate_PartionGoods.ValueData > zc_DateStart() THEN zfConvert_DateToString (MIDate_PartionGoods.ValueData) ELSE '' END
    || ';'
        FROM MovementItem
             LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                              ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                             AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
             LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                        ON MIDate_PartionGoods.MovementItemId = MovementItem.Id
                                       AND MIDate_PartionGoods.DescId         = zc_MIDate_PartionGoods()
             LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                         ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                        AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
             LEFT JOIN MovementItemFloat AS MIFloat_Price
                                         ON MIFloat_Price.MovementItemId = MovementItem.Id
                                        AND MIFloat_Price.DescId = zc_MIFloat_Price()
             LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                         ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                        AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
             LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                         ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                        AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()
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

             LEFT JOIN tmpStickerProperty ON tmpStickerProperty.GoodsId     = MovementItem.ObjectId
                                         AND tmpStickerProperty.GoodsKindId = MILinkObject_GoodsKind.ObjectId
                                         AND tmpStickerProperty.Ord         = 1

        WHERE MovementItem.MovementId = inMovementId
          AND MovementItem.DescId = zc_MI_Master()
          AND MovementItem.isErased = FALSE
          AND MIFloat_AmountPartner.ValueData <> 0
       ;
     --- 
     
     ELSE

     -- !!!7.Формат txt - zc_Enum_ExportKind_Tavr31929492!!!

     IF vbExportKindId = zc_Enum_ExportKind_Tavr31929492()
     THEN

     -- Строчная часть
     INSERT INTO _Result(RowData)
         WITH tmpObject_GoodsPropertyValue AS
                (SELECT ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                      , ObjectLink_GoodsPropertyValue_Goods.ChildObjectId                   AS GoodsId
                      , COALESCE (ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId, 0) AS GoodsKindId
                      , ObjectString_BarCode.ValueData       AS BarCode
                      , ObjectString_Article.ValueData       AS Article
                      , Object_GoodsPropertyValue.ValueData  AS Name
                 FROM (SELECT vbGoodsPropertyId AS GoodsPropertyId WHERE vbGoodsPropertyId <> 0
                      ) AS tmpGoodsProperty
                      INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                            ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = tmpGoodsProperty.GoodsPropertyId
                                           AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
                      LEFT JOIN Object AS Object_GoodsPropertyValue ON Object_GoodsPropertyValue.Id = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId

                      LEFT JOIN ObjectString AS ObjectString_BarCode
                                             ON ObjectString_BarCode.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                            AND ObjectString_BarCode.DescId = zc_ObjectString_GoodsPropertyValue_BarCode()
                      LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                           ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                          AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
                      LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                           ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                          AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
                      LEFT JOIN ObjectString AS ObjectString_Article
                                             ON ObjectString_Article.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                            AND ObjectString_Article.DescId = zc_ObjectString_GoodsPropertyValue_Article()
                )
           , tmpObject_GoodsPropertyValueGroup AS
                (SELECT tmpObject_GoodsPropertyValue.GoodsId
                      , tmpObject_GoodsPropertyValue.BarCode
                      , tmpObject_GoodsPropertyValue.Article
                      , tmpObject_GoodsPropertyValue.Name
                 FROM (SELECT MAX (tmpObject_GoodsPropertyValue.ObjectId) AS ObjectId, GoodsId FROM tmpObject_GoodsPropertyValue WHERE Article <> '' GROUP BY GoodsId
                      ) AS tmpGoodsProperty_find
                      LEFT JOIN tmpObject_GoodsPropertyValue ON tmpObject_GoodsPropertyValue.ObjectId =  tmpGoodsProperty_find.ObjectId
                )
           , tmpObject_GoodsPropertyValue_basis AS
                (SELECT ObjectLink_GoodsPropertyValue_Goods.ObjectId      AS ObjectId
                      , ObjectLink_GoodsPropertyValue_Goods.ChildObjectId AS GoodsId
                      , COALESCE (ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId, 0) AS GoodsKindId
                      , ObjectString_BarCode.ValueData       AS BarCode
                      , ObjectString_Article.ValueData       AS Article
                      , Object_GoodsPropertyValue.ValueData  AS Name
                 FROM (SELECT vbGoodsPropertyId_basis AS GoodsPropertyId
                      ) AS tmpGoodsProperty
                      INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                            ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = tmpGoodsProperty.GoodsPropertyId
                                           AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
                      INNER JOIN Object AS Object_GoodsPropertyValue ON Object_GoodsPropertyValue.Id = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
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
           , tmpObject_GoodsPropertyValueGroup_basis AS
             (SELECT tmpObject_GoodsPropertyValue.GoodsId
                   , tmpObject_GoodsPropertyValue.Name
                   , tmpObject_GoodsPropertyValue.BarCode
              FROM (SELECT MAX (tmpObject_GoodsPropertyValue.ObjectId) AS ObjectId, GoodsId FROM tmpObject_GoodsPropertyValue_basis AS tmpObject_GoodsPropertyValue WHERE BarCode <> '' OR Name <> '' GROUP BY GoodsId
                   ) AS tmpGoodsProperty_find
                   LEFT JOIN tmpObject_GoodsPropertyValue_basis AS tmpObject_GoodsPropertyValue ON tmpObject_GoodsPropertyValue.ObjectId =  tmpGoodsProperty_find.ObjectId
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
               -- штрихкод
                CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Kg() 
                     THEN 'weight' 
                     ELSE COALESCE (tmpObject_GoodsPropertyValue.BarCode, COALESCE (tmpObject_GoodsPropertyValueGroup.BarCode, COALESCE (tmpObject_GoodsPropertyValue_basis.BarCode, '')))
                END  :: TVarChar
 
               -- артикул 
     || '@' || COALESCE (tmpObject_GoodsPropertyValue.Article, COALESCE (tmpObject_GoodsPropertyValueGroup.Article, COALESCE (tmpObject_GoodsPropertyValue_basis.Article, ''))) :: TVarChar 

               --наименование  как в печати
     || '@' ||(CASE WHEN tmpObject_GoodsPropertyValue.Name            <> '' THEN tmpObject_GoodsPropertyValue.Name
                    WHEN tmpObject_GoodsPropertyValueGroup.Name       <> '' THEN tmpObject_GoodsPropertyValueGroup.Name
                    WHEN tmpObject_GoodsPropertyValue_basis.Name      <> '' THEN tmpObject_GoodsPropertyValue_basis.Name
                    WHEN tmpObject_GoodsPropertyValueGroup_basis.Name <> '' THEN tmpObject_GoodsPropertyValueGroup_basis.Name
                    WHEN ObjectString_Goods_BUH.ValueData <> '' AND vbOperDate >= ObjectDate_BUH.ValueData THEN Object_Goods.ValueData
                    --WHEN COALESCE (tmpMI_Tax.isName_new, FALSE)      = TRUE THEN Object_Goods.ValueData
                    WHEN ObjectString_Goods_BUH.ValueData             <> '' THEN ObjectString_Goods_BUH.ValueData
                    ELSE Object_Goods.ValueData
               END
              || CASE WHEN COALESCE (Object_GoodsKind.Id, zc_Enum_GoodsKind_Main()) = zc_Enum_GoodsKind_Main() THEN '' ELSE ' ' || Object_GoodsKind.ValueData END
                ) :: TVarChar
             
               -- Кол-во
     || '@' || (MIFloat_AmountPartner.ValueData :: NUMERIC (16, 3)) :: TVarChar
               -- Цена с НДС
     --|| '@' || CASE WHEN MIFloat_CountForPrice.ValueData > 1 THEN CAST (1.2 * MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 3)) ELSE CAST (1.2 * MIFloat_Price.ValueData AS NUMERIC (16, 3)) END :: TVarChar
                   -- Цена без НДС
     || '@' || CASE WHEN MIFloat_CountForPrice.ValueData > 1 THEN CAST (1 * MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 2)) ELSE CAST (1 * MIFloat_Price.ValueData AS NUMERIC (16, 2)) END :: TVarChar
     || '@@'
     
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

             LEFT JOIN tmpGoodsByGoodsKind ON tmpGoodsByGoodsKind.GoodsId = MovementItem.ObjectId
                                          AND tmpGoodsByGoodsKind.GoodsKindId = COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
             LEFT JOIN tmpObject_GoodsPropertyValue ON tmpObject_GoodsPropertyValue.GoodsId = MovementItem.ObjectId
                                                   AND tmpObject_GoodsPropertyValue.GoodsKindId = COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                                                   AND tmpObject_GoodsPropertyValue.BarCode <> ''
             LEFT JOIN tmpObject_GoodsPropertyValueGroup ON tmpObject_GoodsPropertyValueGroup.GoodsId = MovementItem.ObjectId
                                                        AND tmpObject_GoodsPropertyValue.GoodsId IS NULL
             LEFT JOIN tmpObject_GoodsPropertyValue_basis ON tmpObject_GoodsPropertyValue_basis.GoodsId = MovementItem.ObjectId
                                                         AND tmpObject_GoodsPropertyValue_basis.GoodsKindId = COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
             LEFT JOIN tmpObject_GoodsPropertyValueGroup_basis ON tmpObject_GoodsPropertyValueGroup_basis.GoodsId = MovementItem.ObjectId
             
             LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                  ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                                 AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
             
             --LEFT JOIN Object AS Object_Measure   ON Object_Measure.Id   = ObjectLink_Goods_Measure.ChildObjectId
             
             LEFT JOIN Object AS Object_Goods     ON Object_Goods.Id     = MovementItem.ObjectId
             LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId
             
             LEFT JOIN ObjectString AS ObjectString_Goods_BUH
                                    ON ObjectString_Goods_BUH.ObjectId = MovementItem.ObjectId
                                   AND ObjectString_Goods_BUH.DescId = zc_ObjectString_Goods_BUH()
             LEFT JOIN ObjectDate AS ObjectDate_BUH
                                  ON ObjectDate_BUH.ObjectId = MovementItem.ObjectId
                                 AND ObjectDate_BUH.DescId = zc_ObjectDate_Goods_BUH()

        WHERE MovementItem.MovementId = inMovementId
          AND MovementItem.DescId = zc_MI_Master()
          AND MovementItem.isErased = FALSE
          AND MIFloat_AmountPartner.ValueData <> 0
        ORDER BY CASE WHEN ObjectString_Goods_BUH.ValueData <> '' AND vbOperDate >= ObjectDate_BUH.ValueData THEN ObjectString_Goods_BUH.ValueData ELSE Object_Goods.ValueData END
               , Object_GoodsKind.ValueData
       ;
     
     
     END IF;
     END IF;
     END IF;
     END IF;
     END IF;
     END IF;
     END IF;

     IF vbExportKindId IN (zc_Enum_ExportKind_Vez37171990(), zc_Enum_ExportKind_Brusn34604386())
     THEN
         -- Результат
         RETURN QUERY
            SELECT STRING_AGG (_Result.RowData, CHR(13)||CHR(10)) :: TBlob FROM _Result;
     ELSE
         -- Результат
         RETURN QUERY
            SELECT _Result.RowData FROM _Result;
     END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Левицкий Б.
 11.03.20         * add --!!! 6 --
 29.07.16                                                                       * Шери - XML формат : цены в колонке " KOL="* формируются для каждой позиции отдельно с учетом скидки/накрутки
 10.05.16                                                                       * Шери - XML формат : не учитывалась скидка/накрутка при формировании цены в колонке " KOL="*
 05.05.16                                                                       * Допилена выгрузка для Шери - XML формат
 23.03.16                                        *
 25.02.16                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_Email_Send (inMovementId:= 3376510, inSession:= zfCalc_UserAdmin()) -- zc_Enum_ExportKind_Mida35273055()
-- SELECT * FROM gpSelect_Movement_Email_Send (inMovementId:= 3252496, inSession:= zfCalc_UserAdmin()) -- zc_Enum_ExportKind_Vez37171990()
-- SELECT * FROM gpSelect_Movement_Email_Send (inMovementId:= 4953855, inSession:= zfCalc_UserAdmin()) -- zc_Enum_ExportKind_Brusn34604386()
-- SELECT * FROM gpSelect_Movement_Email_Send (inMovementId:= 6887493 , inSession:= zfCalc_UserAdmin()) -- zc_Enum_ExportKind_Dakort39135074()
-- SELECT * FROM gpSelect_Movement_Email_Send (inMovementId:= 15595974, inSession:= zfCalc_UserAdmin()) -- zc_Enum_ExportKind_Glad2514900150()
