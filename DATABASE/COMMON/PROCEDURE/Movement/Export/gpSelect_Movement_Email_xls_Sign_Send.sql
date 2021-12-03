-- Function: gpSelect_Movement_Email_xls_Sign_Send(Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Movement_Email_xls_Sign_Send (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Email_xls_Sign_Send(
    IN inMovementId           Integer   ,
    IN inSession              TVarChar    -- сессия пользователя
)
RETURNS TABLE (Sign TBlob)
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

    DECLARE vbTotalCountSh_Kg TFloat;
    DECLARE vbTotalCountKg_only TFloat;
    
    DECLARE vbCount TFloat;
    DECLARE vbOKPO TVarChar;
    DECLARE vbStoreKeeperName TVarChar;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Email_Send());
     vbUserId := lpGetUserBySession (inSession);


     vbOKPO:= (SELECT OH_JuridicalDetails.OKPO
               FROM MovementLinkObject
                    LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                         ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject.ObjectId
                                        AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                    LEFT JOIN ObjectHistory_JuridicalDetails_View AS OH_JuridicalDetails
                                                                  ON OH_JuridicalDetails.JuridicalId = ObjectLink_Partner_Juridical.ChildObjectId
               WHERE MovementLinkObject.MovementId = inMovementId
                 AND MovementLinkObject.DescId = zc_MovementLinkObject_To()
               );

     -- параметры из Взвешивания
     vbStoreKeeperName:= (SELECT Object_User.ValueData
                          FROM Movement
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_User
                                                            ON MovementLinkObject_User.MovementId = Movement.Id
                                                           AND MovementLinkObject_User.DescId = zc_MovementLinkObject_User()
                               LEFT JOIN Object AS Object_User ON Object_User.Id = MovementLinkObject_User.ObjectId
                          WHERE Movement.ParentId = inMovementId AND Movement.DescId IN (zc_Movement_WeighingPartner(), zc_Movement_WeighingProduction())
                            AND Movement.StatusId = zc_Enum_Status_Complete()
                          LIMIT 1
                         );

    CREATE TEMP TABLE tmpObject_GoodsPropertyValue (ObjectId Integer, GoodsId Integer, GoodsKindId Integer, Name TVarChar,
                                                    BarCode TVarChar, Article TVarChar,
                                                    BarCodeGLN  TVarChar, ArticleGLN TVarChar,
                                                    isWeigth Boolean) ON COMMIT DROP;
    INSERT INTO  tmpObject_GoodsPropertyValue (ObjectId, GoodsId, GoodsKindId, Name, BarCode, Article, BarCodeGLN, ArticleGLN, isWeigth)
        SELECT ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
             , ObjectLink_GoodsPropertyValue_Goods.ChildObjectId                   AS GoodsId
             , COALESCE (ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId, 0) AS GoodsKindId
             , Object_GoodsPropertyValue.ValueData  AS Name
             , ObjectString_BarCode.ValueData       AS BarCode
             , ObjectString_Article.ValueData       AS Article
             , ObjectString_BarCodeGLN.ValueData    AS BarCodeGLN
             , ObjectString_ArticleGLN.ValueData    AS ArticleGLN
             , COALESCE (ObjectBoolean_Weigth.ValueData, FALSE) :: Boolean AS isWeigth
        FROM (SELECT vbGoodsPropertyId AS GoodsPropertyId WHERE vbGoodsPropertyId <> 0
             ) AS tmpGoodsProperty
             INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                   ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = tmpGoodsProperty.GoodsPropertyId
                                  AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
             LEFT JOIN Object AS Object_GoodsPropertyValue ON Object_GoodsPropertyValue.Id = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
             LEFT JOIN ObjectString AS ObjectString_BarCode
                                    ON ObjectString_BarCode.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                   AND ObjectString_BarCode.DescId = zc_ObjectString_GoodsPropertyValue_BarCode()
             LEFT JOIN ObjectString AS ObjectString_Article
                                    ON ObjectString_Article.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                   AND ObjectString_Article.DescId = zc_ObjectString_GoodsPropertyValue_Article()

             LEFT JOIN ObjectString AS ObjectString_BarCodeGLN
                                    ON ObjectString_BarCodeGLN.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                   AND ObjectString_BarCodeGLN.DescId = zc_ObjectString_GoodsPropertyValue_BarCodeGLN()
             LEFT JOIN ObjectString AS ObjectString_ArticleGLN
                                    ON ObjectString_ArticleGLN.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                   AND ObjectString_ArticleGLN.DescId = zc_ObjectString_GoodsPropertyValue_ArticleGLN()

             LEFT JOIN ObjectBoolean AS ObjectBoolean_Weigth
                                     ON ObjectBoolean_Weigth.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                    AND ObjectBoolean_Weigth.DescId = zc_ObjectBoolean_GoodsPropertyValue_Weigth()

             LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                  ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                 AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
             LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                  ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                 AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
         ;

            -- Расчет шт для штучного товара, который нужно показать как кг, чтоб снять это кол-во с итого шт.
        SELECT TotalCountSh_Kg, TotalCountKg_only, Count
               INTO vbTotalCountSh_Kg, vbTotalCountKg_only, vbCount
        FROM (SELECT -- для ШТ, если сво-во tmpObject_GoodsPropertyValue.isWeigth = TRUE, нужно єто кол-во снять с итого шт.
                     SUM (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() AND COALESCE (tmpObject_GoodsPropertyValue.isWeigth,FALSE) = TRUE
                                    THEN tmpMI.Amount
                               ELSE 0
                          END) AS TotalCountSh_Kg
                         -- ВЕС - только если весовой
                   , SUM (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()
                               THEN 0
                          WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Kg()
                               THEN tmpMI.Amount
                          ELSE 0
                     END) AS TotalCountKg_only
                   , Count (*) AS Count
              FROM (SELECT MovementItem.ObjectId AS GoodsId
                         , COALESCE (MILinkObject_GoodsKind.ObjectId, zc_GoodsKind_Basis()) AS GoodsKindId
                         , SUM (CASE WHEN Movement.DescId IN (zc_Movement_Sale())
                                          THEN COALESCE (MIFloat_AmountPartner.ValueData, 0)
                                     ELSE MovementItem.Amount
                                END) AS Amount
                    FROM MovementItem
                         INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
                         LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                     ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                    AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                         LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                     ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                    AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                         LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                          ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                         AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                    WHERE MovementItem.MovementId = inMovementId
                      AND MovementItem.isErased = FALSE
                    GROUP BY MovementItem.ObjectId
                           , MILinkObject_GoodsKind.ObjectId
                   ) AS tmpMI
                        LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                             ON ObjectLink_Goods_Measure.ObjectId = tmpMI.GoodsId
                                            AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()

                        LEFT JOIN tmpObject_GoodsPropertyValue ON tmpObject_GoodsPropertyValue.GoodsId = tmpMI.GoodsId
                                                              AND tmpObject_GoodsPropertyValue.GoodsKindId = tmpMI.GoodsKindId
                                                              AND (tmpObject_GoodsPropertyValue.Article <> ''
                                                                OR tmpObject_GoodsPropertyValue.BarCode <> ''
                                                                OR tmpObject_GoodsPropertyValue.ArticleGLN <> ''
                                                                OR tmpObject_GoodsPropertyValue.Name <> '')
             ) AS tmpMI;

     -- параметры из документа
     RETURN QUERY
     WITH
     tmpMovementFloat AS (SELECT *
                          FROM MovementFloat
                          WHERE MovementFloat.MovementId = inMovementId
                            AND MovementFloat.DescId IN (zc_MovementFloat_TotalCountKg()
                                                       , zc_MovementFloat_TotalCountSh()
                                                       , zc_MovementFloat_TotalSummMVAT()
                                                       , zc_MovementFloat_TotalSummPVAT()
                                                       , zc_MovementFloat_TotalSumm()
                                                         )
                          )
     
    , tmpData AS (SELECT --zfConvert_FIO (Object_PersonalStore_View.PersonalName, 2, FALSE)  AS StoreKeeper -- кладовщик
                        CASE WHEN COALESCE (Object_PersonalStore_View.PersonalName, '') <> '' THEN zfConvert_FIO (Object_PersonalStore_View.PersonalName, 2, FALSE) ELSE vbStoreKeeperName END  AS StoreKeeper -- кладовщик
                      , MovementFloat_TotalCount.ValueData         AS TotalCount

                      , MovementFloat_TotalCountKg.ValueData  AS TotalCountKg
                      , MovementFloat_TotalCountSh.ValueData - COALESCE (vbTotalCountSh_Kg,0)  AS TotalCountSh
          
                      , MovementFloat_TotalSummMVAT.ValueData  AS TotalSummMVAT
                      , MovementFloat_TotalSummPVAT.ValueData  AS TotalSummPVAT
                      , MovementFloat_TotalSummPVAT.ValueData - MovementFloat_TotalSummMVAT.ValueData  AS SummVAT
                      , MovementFloat_TotalSumm.ValueData  AS TotalSumm

                 FROM Movement
                      LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                   ON MovementLinkObject_From.MovementId = Movement.Id
                                                  AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()

                      LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                                           ON ObjectLink_Unit_Branch.ObjectId = MovementLinkObject_From.ObjectId
                                          AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
          
                      LEFT JOIN ObjectLink AS ObjectLink_Branch_PersonalStore
                                           ON ObjectLink_Branch_PersonalStore.ObjectId = ObjectLink_Unit_Branch.ChildObjectId
                                          AND ObjectLink_Branch_PersonalStore.DescId = zc_ObjectLink_Branch_PersonalStore()
                      LEFT JOIN Object_Personal_View AS Object_PersonalStore_View ON Object_PersonalStore_View.PersonalId = ObjectLink_Branch_PersonalStore.ChildObjectId
          
                      LEFT JOIN tmpMovementFloat AS MovementFloat_TotalCount
                                                 ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                                AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCountPartner()
                      LEFT JOIN tmpMovementFloat AS MovementFloat_TotalCountKg
                                                 ON MovementFloat_TotalCountKg.MovementId =  Movement.Id
                                                AND MovementFloat_TotalCountKg.DescId = zc_MovementFloat_TotalCountKg()
                      LEFT JOIN tmpMovementFloat AS MovementFloat_TotalCountSh
                                                 ON MovementFloat_TotalCountSh.MovementId =  Movement.Id
                                                AND MovementFloat_TotalCountSh.DescId = zc_MovementFloat_TotalCountSh()
                      LEFT JOIN tmpMovementFloat AS MovementFloat_TotalSummMVAT
                                                 ON MovementFloat_TotalSummMVAT.MovementId =  Movement.Id
                                                AND MovementFloat_TotalSummMVAT.DescId = zc_MovementFloat_TotalSummMVAT()
                      LEFT JOIN tmpMovementFloat AS MovementFloat_TotalSummPVAT
                                                 ON MovementFloat_TotalSummPVAT.MovementId =  Movement.Id
                                                AND MovementFloat_TotalSummPVAT.DescId = zc_MovementFloat_TotalSummPVAT()
                      LEFT JOIN tmpMovementFloat AS MovementFloat_TotalSumm
                                                 ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                                AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
          
                     WHERE Movement.Id = inMovementId
                 )
          

     SELECT tmp.Sign
     FROM (
       SELECT tmp.Sign, tmp.Num
       FROM (
--     SELECT ('          Разом кг   ' || tmpData.TotalCountKg) :: TBlob
--     FROM tmpData
-- UNION ALL
       SELECT ('Вага (кг): ' || zfConvert_FloatToString (tmpData.TotalCountKg)
            || '                              '
            || 'Разом сума без ПДВ:'
            || '  '
            || zfConvert_FloatToString (tmpData.TotalSummMVAT)
            || '  '
              ) :: TBlob AS Sign
            , 1 AS Num
       FROM tmpData
   UNION ALL
       SELECT ('Сума ПДВ:'
            || '  '
            || zfConvert_FloatToString (COALESCE (tmpData.TotalSummPVAT,0) - COALESCE (tmpData.TotalSummMVAT,0))
            || '  '
              ) :: TBlob
            , 2 AS Num
       FROM tmpData
   UNION ALL
       SELECT ('Всього із ПДВ: '
            || '  '
            || zfConvert_FloatToString (tmpData.TotalSummPVAT)
            || '  '
              ) :: TBlob
            , 3 AS Num
       FROM tmpData

   UNION ALL
       SELECT '' :: TBlob
            , 4 AS Num

   UNION ALL
       SELECT ('Всього найменувань '||zfConvert_FloatToString (vbCount)|| ', на суму ' || zfConvert_FloatToString (tmpData.TotalSummPVAT) ||' грн.' ) :: TBlob
            , 5 AS Num
       FROM tmpData

   UNION ALL
       SELECT ('_______________________________________________________________________________________________' ) :: TBlob
            , 10 AS Num

   UNION ALL
       SELECT '' :: TBlob
            , 11 AS Num
       FROM tmpData

   UNION ALL
     --SELECT ('     Від постачальника : комірник ' || tmpData.StoreKeeper||'                       Отримав:' ) :: TBlob
       SELECT ('                   Від постачальника                                                              Отримав:' ) :: TBlob
            , 12 AS Num
       FROM tmpData

   UNION ALL
       SELECT '' :: TBlob
            , 13 AS Num
   UNION ALL
       SELECT ('     ________________________________                           _____________________________' ) :: TBlob
            , 14 AS Num

   UNION ALL
       SELECT '' :: TBlob
            , 15 AS Num
   UNION ALL
       SELECT ('         * Відповідальний за здійснення господарської' ) :: TBlob
            , 21 AS Num

   UNION ALL
       SELECT ('             операції і правильність її оформлення                      За довіреністю №          від') :: TBlob
            , 22 AS Num

      ) AS tmp
    WHERE vbOKPO <> '2244900110'
    
     UNION  
     -- для vbOKPO = 2244900110  Недавній Олександр Миколайович ФОП  - максимально как печ. форма
       SELECT tmp.Sign, tmp.Num
       FROM (
             SELECT ('                                             Всьго кількість (кг): ' || zfConvert_FloatToString (tmpData.TotalCountKg)
                    ) :: TBlob AS Sign
                  , 1 AS Num
             FROM tmpData
         UNION ALL
             SELECT ('                                             Всьго кількість (шт): '|| zfConvert_FloatToString (tmpData.TotalCountSh)
                    ) :: TBlob
                  , 2 AS Num
             FROM tmpData
         UNION ALL
             SELECT ('                                             Всього без ПДВ:       ' || zfConvert_FloatToString (tmpData.TotalSummMVAT)
                    ) :: TBlob
                  , 3 AS Num
             FROM tmpData
         UNION ALL
             SELECT ('                                             ПДВ:                  '|| zfConvert_FloatToString (tmpData.SummVAT)
                    ) :: TBlob
                  , 4 AS Num
             FROM tmpData
         UNION ALL
             SELECT ('                                             Всього із ПДВ:        '|| zfConvert_FloatToString (tmpData.TotalSummPVAT)
                    ) :: TBlob
                  , 5 AS Num
             FROM tmpData
      
         UNION ALL
             SELECT '' :: TBlob
                  , 6 AS Num
         UNION ALL
             SELECT '' :: TBlob
                  , 7 AS Num
             FROM tmpData
      
         UNION ALL
           SELECT (' Здав: комірник ' || tmpData.StoreKeeper||'                                             Прийняв:' ) :: TBlob
                  , 8 AS Num
             FROM tmpData
         UNION ALL
             SELECT '' :: TBlob
                  , 9 AS Num
         UNION ALL
             SELECT ('     ________________________________                                             _____________________________' ) :: TBlob
                  , 10 AS Num      
            ) AS tmp
       WHERE vbOKPO = '2244900110'
        ) AS tmp
       ORDER BY tmp.Num

       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.04.21         *
 01.04.21                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_Email_xls_Sign_Send (inMovementId:= 19556147, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_Movement_Email_xls_Sign_Send (inMovementId:= 21495529, inSession:= zfCalc_UserAdmin())
