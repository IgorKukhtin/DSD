-- Function: gpGet_Movement_Quality_ReportName()

DROP FUNCTION IF EXISTS gpGet_Movement_Quality_ReportName (Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpGet_Movement_Quality_ReportName (
    IN inMovementId         Integer  , -- ключ Документа
    IN inSession            TVarChar   -- сессия пользователя
)
RETURNS TVarChar
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPrintFormName TVarChar;
   DECLARE vbIsGoodsCode_2393 Boolean;
BEGIN
       -- проверка прав пользователя на вызов процедуры
       -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Quality());
       vbUserId:= lpGetUserBySession (inSession);
     
 
       -- КОВБАСКИ БАВАРСЬКІ С/К в/г ПРЕМІЯ 120 гр/шт + 2222 + 2369
       vbIsGoodsCode_2393:= EXISTS (SELECT 1 
                                    FROM MovementItem AS MI
                                         JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                                                         ON ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId = MI.ObjectId
                                                        AND ObjectLink_GoodsByGoodsKind_Goods.DescId        = zc_ObjectLink_GoodsByGoodsKind_Goods()
                                         JOIN ObjectBoolean AS ObjectBoolean_NewQuality
                                                            ON ObjectBoolean_NewQuality.ObjectId  = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                           AND ObjectBoolean_NewQuality.DescId    = zc_ObjectBoolean_GoodsByGoodsKind_NewQuality()
                                                           AND ObjectBoolean_NewQuality.ValueData = TRUE

                                    WHERE MI.MovementId = inMovementId
                                      AND MI.DescId = zc_MI_Master()
                                      AND MI.isErased = FALSE
                                    --AND MI.ObjectId IN (6048195, 417105, 2617313)
                                    --and inMovementId <> 25604278 
                                   );

       --
       SELECT CASE WHEN vbUserId = 5 AND 1=0 THEN 'PrintMovement_Quality32294926'

                   WHEN vbIsGoodsCode_2393 = TRUE AND OH_JuridicalDetails.OKPO =  '32049199' THEN 'PrintMovement_Quality32049199_2393'
                   WHEN vbIsGoodsCode_2393 = TRUE AND OH_JuridicalDetails.OKPO <> '32049199' THEN 'PrintMovement_Quality32294926'

                   WHEN ObjectLink_Juridical_Retail.ChildObjectId   = 310855 -- Варус
                    AND ObjectLink_Contract_InfoMoney.ChildObjectId = zc_Enum_InfoMoney_30101() -- Готовая продукция
                    --AND vbUserId <> 5
                        THEN 'PrintMovement_Quality32294926' -- 'PrintMovement_Quality310855'

                   ELSE COALESCE (PrintForms_View.PrintFormName, 'PrintMovement_Quality')
              END
              INTO vbPrintFormName

       FROM Movement
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId     = zc_MovementLinkObject_Contract()
            LEFT JOIN ObjectLink AS ObjectLink_Contract_InfoMoney
                                 ON ObjectLink_Contract_InfoMoney.ObjectId = MovementLinkObject_Contract.ObjectId
                                AND ObjectLink_Contract_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()
     
            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                 ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                                AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
            LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                 ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                AND ObjectLink_Juridical_Retail.DescId   = zc_ObjectLink_Juridical_Retail()

            LEFT JOIN ObjectHistory_JuridicalDetails_View AS OH_JuridicalDetails ON OH_JuridicalDetails.JuridicalId = CASE WHEN Movement.DescId = zc_Movement_TransferDebtOut() THEN MovementLinkObject_To.ObjectId ELSE ObjectLink_Partner_Juridical.ChildObjectId END
     
            LEFT JOIN PrintForms_View
                   ON Movement.OperDate BETWEEN PrintForms_View.StartDate AND PrintForms_View.EndDate
                  AND PrintForms_View.JuridicalId = CASE WHEN Movement.DescId = zc_Movement_TransferDebtOut() THEN MovementLinkObject_To.ObjectId ELSE ObjectLink_Partner_Juridical.ChildObjectId END
                  AND PrintForms_View.ReportType = 'Quality'
                  AND PrintForms_View.DescId = zc_Movement_Sale()
                  AND (vbIsGoodsCode_2393 = TRUE
                    OR OH_JuridicalDetails.OKPO NOT IN ('32294926', '40720198', '32294897')
                      )
       WHERE Movement.Id = inMovementId
         AND Movement.DescId = zc_Movement_Sale();

     RETURN (vbPrintFormName);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.22.18         *
*/

-- тест
-- SELECT * FROM gpGet_Movement_Quality_ReportName (inMovementId:= 21043705, inSession:= '5'); -- все
