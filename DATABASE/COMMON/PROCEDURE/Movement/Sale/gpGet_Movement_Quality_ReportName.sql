-- Function: gpGet_Movement_Quality_ReportName()

DROP FUNCTION IF EXISTS gpGet_Movement_Quality_ReportName (Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpGet_Movement_Quality_ReportName (
    IN inMovementId         Integer  , -- ключ Документа
    IN inSession            TVarChar   -- сессия пользователя
)
RETURNS TVarChar
AS
$BODY$
   DECLARE vbPrintFormName TVarChar;
   DECLARE vbIsGoodsCode_2393 Boolean;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Quality());
     
       -- КОВБАСКИ БАВАРСЬКІ С/К в/г ПРЕМІЯ 120 гр/шт + 2222
       vbIsGoodsCode_2393:= EXISTS (SELECT 1 FROM MovementItem AS MI WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Master() AND MI.isErased = FALSE AND MI.ObjectId IN (6048195, 417105));

       --
       SELECT COALESCE (PrintForms_View.PrintFormName, 'PrintMovement_Quality')
              INTO vbPrintFormName
       FROM Movement
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
     
            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                 ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                                AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()

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
--SELECT * FROM gpGet_Movement_Quality_ReportName(inMovementId := 35168,  inSession := '5'); -- все
