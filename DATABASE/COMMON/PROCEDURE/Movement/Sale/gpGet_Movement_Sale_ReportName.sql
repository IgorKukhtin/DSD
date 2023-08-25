-- Function: gpGet_Movement_Sale_ReportName()

DROP FUNCTION IF EXISTS gpGet_Movement_Sale_ReportName (Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpGet_Movement_Sale_ReportName (
    IN inMovementId         Integer  , -- ключ Документа
    IN inSession            TVarChar   -- сессия пользователя
)
RETURNS TVarChar
AS
$BODY$
   DECLARE vbPrintFormName TVarChar;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Sale());

     vbPrintFormName:=
      (WITH tmpPack AS (SELECT SUM (CASE WHEN (MovementItem.Amount <> 0 OR MIFloat_AmountPartner.ValueData <> 0) THEN 1 ELSE 0 END) AS Ord1
                             , SUM (CASE WHEN (MovementItem.Amount <> 0 OR MIFloat_AmountPartner.ValueData <> 0)
                                          AND ObjectLink_InfoMoney.ChildObjectId IN (zc_Enum_InfoMoney_10202() -- Прочее сырье + Оболочка
                                                                                   , zc_Enum_InfoMoney_10203() -- Прочее сырье + Упаковка
                                                                                   , zc_Enum_InfoMoney_10204() -- Прочее сырье + Прочее сырье
                                                                                   , zc_Enum_InfoMoney_20501() -- Общефирменные + "Оборотная тара"
                                                                                   , zc_Enum_InfoMoney_20601() -- Общефирменные + "Прочие материалы"
                                                                                    )
                                         THEN 1
                                         ELSE 0
                                    END) AS Ord2
                        FROM MovementItem
                             LEFT JOIN ObjectLink AS ObjectLink_InfoMoney
                                                  ON ObjectLink_InfoMoney.ObjectId = MovementItem.ObjectId
                                                 AND ObjectLink_InfoMoney.DescId   = zc_ObjectLink_Goods_InfoMoney()
                             LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                         ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                        AND MIFloat_AmountPartner.DescId         = zc_MIFloat_AmountPartner()
                        WHERE MovementItem.MovementId = inMovementId AND MovementItem.DescId = zc_MI_Master() AND MovementItem.isErased = FALSE
                       )
       -- Результат
       SELECT CASE -- !!!захардкодил для Contract - JuridicalInvoice!!!
                   WHEN ObjectLink_Contract_JuridicalInvoice.ChildObjectId > 0
                    AND MovementLinkObject_PaidKind.ObjectId = zc_Enum_PaidKind_FirstForm()
                        THEN 'PrintMovement_SaleJuridicalInvoice'

                   -- !!!захардкодил для Гофротары!!!
                   WHEN EXISTS (SELECT 1 FROM tmpPack WHERE tmpPack.Ord1 = tmpPack.Ord2)
                    AND Movement.DescId <> zc_Movement_Loss()
                        THEN 'PrintMovement_SalePackWeight'

                   -- !!!захардкодил временно для Запорожье!!!
                   WHEN MovementLinkObject_From.ObjectId IN (301309) -- Склад ГП ф.Запорожье
                    AND MovementLinkObject_PaidKind.ObjectId = zc_Enum_PaidKind_SecondForm()
                        THEN PrintForms_View_Default.PrintFormName

                   -- новая форма для Жук А.Н. Товарная накладная
                   WHEN MovementLinkObject_To.ObjectId = 3683763   
                        THEN 'PrintMovement_Sale2_3683763'

                   -- !!!захардкодил временно для БН с НДС!!!
                   WHEN MB_PriceWithVAT.ValueData = TRUE
                    AND MovementLinkObject_PaidKind.ObjectId = zc_Enum_PaidKind_FirstForm()
                    AND OH_JuridicalDetails.OKPO NOT IN ('26632252') 
                        THEN 'PrintMovement_Sale2PriceWithVAT'

                   ELSE COALESCE (PrintForms_View.PrintFormName, PrintForms_View_Default.PrintFormName)
              END AS PrintFormName

       FROM Movement
            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                         ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                        AND MovementLinkObject_PaidKind.DescId IN (zc_MovementLinkObject_PaidKind(), zc_MovementLinkObject_PaidKindTo())
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId     = zc_MovementLinkObject_Contract()

            LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalInvoice
                                 ON ObjectLink_Contract_JuridicalInvoice.ObjectId = MovementLinkObject_Contract.ObjectId
                                AND ObjectLink_Contract_JuridicalInvoice.DescId   = zc_ObjectLink_Contract_JuridicalInvoice()
            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                 ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                                AND ObjectLink_Partner_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()

            LEFT JOIN MovementBoolean AS MB_PriceWithVAT
                                      ON MB_PriceWithVAT.MovementId = Movement.Id
                                     AND MB_PriceWithVAT.DescId     = zc_MovementBoolean_PriceWithVAT()

            LEFT JOIN ObjectHistory_JuridicalDetails_View AS OH_JuridicalDetails ON OH_JuridicalDetails.JuridicalId = ObjectLink_Partner_Juridical.ChildObjectId

            LEFT JOIN PrintForms_View
                   ON Movement.OperDate BETWEEN PrintForms_View.StartDate AND PrintForms_View.EndDate
                  AND PrintForms_View.JuridicalId = CASE WHEN Movement.DescId = zc_Movement_TransferDebtOut() THEN MovementLinkObject_To.ObjectId ELSE ObjectLink_Partner_Juridical.ChildObjectId END
                  AND PrintForms_View.ReportType = 'Sale'
     --             AND PrintForms_View.DescId = zc_Movement_Sale()

            LEFT JOIN PrintForms_View AS PrintForms_View_Default
                   ON Movement.OperDate BETWEEN PrintForms_View_Default.StartDate AND PrintForms_View_Default.EndDate
                  AND PrintForms_View_Default.JuridicalId = 0
                  AND PrintForms_View_Default.ReportType = 'Sale'
                  AND PrintForms_View_Default.PaidKindId = COALESCE (MovementLinkObject_PaidKind.ObjectId, zc_Enum_PaidKind_SecondForm())
     --             AND PrintForms_View_Default.DescId = zc_Movement_Sale()


       WHERE Movement.Id = inMovementId
       ORDER BY 1 ASC
--         AND Movement.DescId = zc_Movement_Sale()
       LIMIT 1
      );

     RETURN (vbPrintFormName);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_Sale_ReportName (Integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 08.08.19         *
 07.02.14                                                        * + PaidKindId
 06.02.14                                                        *
 05.02.14                                                        *
*/

-- тест
-- SELECT gpGet_Movement_Sale_ReportName FROM gpGet_Movement_Sale_ReportName(inMovementId := 3924205,  inSession := zfCalc_UserAdmin()); -- все
-- SELECT gpGet_Movement_Sale_ReportName FROM gpGet_Movement_Sale_ReportName(inMovementId := 17040004 , inSession:= '4723136'); -- все
