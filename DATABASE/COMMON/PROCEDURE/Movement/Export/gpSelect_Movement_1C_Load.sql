-- Function: gpSelect_Movement_1C_Load()

DROP FUNCTION IF EXISTS gpSelect_Movement_1C_Load (TDateTime, TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_1C_Load(
    IN inStartDate      TDateTime , --
    IN inEndDate        TDateTime , --
    IN inInfoMoneyId    Integer   ,
    IN inPaidKindId     Integer   ,
    IN inSession        TVarChar    -- сессия пользователя
)
RETURNS TABLE (UnitId TVarChar,  VidDoc TVarChar, InvNumber TVarChar, OperDate TVarChar, ClientCode TVarChar, ClientName TVarChar,
               GoodsCode  TVarChar, GoodsName TVarChar, OperCount TVarChar, OperPrice TVarChar, 
               Tax TVarChar, Suma TVarChar, PDV TVarChar, SumaPDV TVarChar,
               ClientINN TVarChar, ClientOKPO TVarChar, CLIENTKIND TVarChar, 
               InvNalog TVarChar, BillId TVarChar, EKSPCODE TVarChar, EXPName TVarChar,            
               GoodsId TVarChar, PackId TVarChar, PackName TVarChar, 
               Doc1Date TVarChar, Doc1Number TVarChar, Doc2Date TVarChar, Doc2Number TVarChar)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_1C_Load());
     vbUserId:= inSession;

     --
     RETURN QUERY
     WITH tmpInfoMoney AS (SELECT Object_InfoMoney_View.InfoMoneyId FROM Object_InfoMoney_View WHERE Object_InfoMoney_View.InfoMoneyId = inInfoMoneyId AND Object_InfoMoney_View.InfoMoneyGroupId <> zc_Enum_InfoMoneyGroup_10000() -- Основное сырье
                          UNION 
                           SELECT Object_InfoMoney_View_find.InfoMoneyId
                           FROM Object_InfoMoney_View
                                LEFT JOIN Object_InfoMoney_View AS Object_InfoMoney_View_find ON Object_InfoMoney_View_find.InfoMoneyDestinationId = Object_InfoMoney_View.InfoMoneyDestinationId
                           WHERE Object_InfoMoney_View.InfoMoneyId = inInfoMoneyId
                             AND Object_InfoMoney_View.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_10000() -- Основное сырье
                          /*UNION 
                           SELECT Object_InfoMoney_View.InfoMoneyId
                           FROM (SELECT 1 FROM Object_InfoMoney_View WHERE Object_InfoMoney_View.InfoMoneyId = inInfoMoneyId
                                                                       AND Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10200() -- Основное сырье + Прочее сырье
                                 LIMIT 1
                                ) AS tmp
                                INNER JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20100() -- Общефирменные + Запчасти и Ремонты
                                                                                                                   , zc_Enum_InfoMoneyDestination_20200() -- Общефирменные + Прочие ТМЦ
                                                                                                                   , zc_Enum_InfoMoneyDestination_20300() -- Общефирменные + МНМА
                                                                                                                   -- , zc_Enum_InfoMoneyDestination_20400() -- Общефирменные + ГСМ
                                                                                                                   , zc_Enum_InfoMoneyDestination_20500() -- Общефирменные + Оборотная тара
                                                                                                                   , zc_Enum_InfoMoneyDestination_20600() -- Общефирменные + Прочие материалы
                                                                                                                    )
                                                                 OR Object_InfoMoney_View.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_70000() -- Инвестиции
*/
                          )

     SELECT
             '0' :: TVarChar                                           AS UnitId
           , CASE WHEN Movement.DescId IN (zc_Movement_PriceCorrective())
                       THEN 123
                  WHEN MovementFloat_TotalSumm.ValueData < 0
                       THEN 123

                  WHEN Movement.DescId IN (zc_Movement_Sale())
                       THEN 2
                  WHEN Movement.DescId IN (zc_Movement_PriceCorrective()) AND MIFloat_Price.ValueData < 0
                       THEN 2
                  WHEN Movement.DescId IN (zc_Movement_TransferDebtOut()) AND View_Contract_InvNumber.InfoMoneyId <> zc_Enum_InfoMoney_20901() -- Ирна
                       THEN 2
                  WHEN Movement.DescId IN (zc_Movement_TransferDebtOut()) AND View_Contract_InvNumber.InfoMoneyId = zc_Enum_InfoMoney_20901() -- Ирна
                       THEN 8

                  WHEN Movement.DescId IN (zc_Movement_ReturnIn())
                       THEN 4
                  WHEN Movement.DescId IN (zc_Movement_PriceCorrective()) AND MIFloat_Price.ValueData >= 0
                       THEN 4
                  WHEN Movement.DescId IN (zc_Movement_TransferDebtIn()) AND View_Contract_InvNumber.InfoMoneyId <> zc_Enum_InfoMoney_20901() -- Ирна
                       THEN 4
                  WHEN Movement.DescId IN (zc_Movement_TransferDebtIn()) AND View_Contract_InvNumber.InfoMoneyId = zc_Enum_InfoMoney_20901() -- Ирна
                       THEN 6

                  WHEN Movement.DescId IN (zc_Movement_Income())
                       THEN 6
                  WHEN Movement.DescId IN (zc_Movement_ReturnOut())
                       THEN 8

             END :: TVarChar                                           AS VidDoc
           , Movement.InvNumber				               AS InvNumber
           , TO_CHAR (Movement.OperDatePartner, 'DD.MM.YYYY') :: TVarChar AS OperDate

           , COALESCE (Object_Partner.Id, 0) :: TVarChar               AS ClientCode
           , Object_Partner.ValueData :: TVarChar                      AS ClientName

           , COALESCE (Object_GoodsByGoodsKind_View.Id, MIMaster.ObjectId) :: TVarChar AS GoodsCode
           , Object_Goods.ValueData                                    AS GoodsName

           , CASE WHEN Movement.DescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn(), zc_Movement_Income(), zc_Movement_ReturnOut())
                       THEN COALESCE (MIFloat_AmountPartner.ValueData, 0)
                  ELSE MIMaster.Amount
             END :: TVarChar                                           AS OperCount
           , (CASE WHEN MovementFloat_ChangePercent.ValueData <> 0
                        THEN CAST ( (1 + MovementFloat_ChangePercent.ValueData / 100) * COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC (16, 2))
                   ELSE COALESCE (MIFloat_Price.ValueData, 0)
              END / CASE WHEN MIFloat_CountForPrice.ValueData <> 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END
            * CASE WHEN Movement.DescId = zc_Movement_PriceCorrective() THEN -1 ELSE 1 END
             ) :: TVarChar                                             AS OperPrice
           , '0' :: TVarChar                                           AS Tax

             -- Сумма без НДС
           , (
             CAST (
             CASE WHEN MovementBoolean_PriceWithVAT.ValueData = FALSE OR COALESCE (MovementFloat_VATPercent.ValueData, 0) = 0
                       -- если цены без НДС или %НДС=0
                       THEN 1
                  WHEN MovementBoolean_PriceWithVAT.ValueData = TRUE
                       -- если цены c НДС
                       THEN 1 / (1 + MovementFloat_VATPercent.ValueData / 100)
             END 
           * CASE WHEN MovementFloat_ChangePercent.ValueData <> 0
                       THEN CAST ( (1 + MovementFloat_ChangePercent.ValueData / 100) * COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC (16, 2))
                  ELSE COALESCE (MIFloat_Price.ValueData, 0)
             END / CASE WHEN MIFloat_CountForPrice.ValueData <> 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END
           * CASE WHEN Movement.DescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn(), zc_Movement_Income(), zc_Movement_ReturnOut())
                       THEN COALESCE (MIFloat_AmountPartner.ValueData, 0)
                  ELSE MIMaster.Amount
             END AS NUMERIC (16, 2)
             )
           * CASE WHEN Movement.DescId = zc_Movement_PriceCorrective() THEN -1 ELSE 1 END
             ) :: TVarChar                       AS Summa

             -- Сумма НДС
           , (
             -- ***Сумма с НДС
             CAST ((
             CAST (
             CASE WHEN MovementFloat_ChangePercent.ValueData <> 0
                       THEN CAST ( (1 + MovementFloat_ChangePercent.ValueData / 100) * COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC (16, 2))
                  ELSE COALESCE (MIFloat_Price.ValueData, 0)
             END / CASE WHEN MIFloat_CountForPrice.ValueData <> 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END
           * CASE WHEN Movement.DescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn(), zc_Movement_Income(), zc_Movement_ReturnOut())
                       THEN COALESCE (MIFloat_AmountPartner.ValueData, 0)
                  ELSE MIMaster.Amount
             END AS NUMERIC (16, 2))
           * CASE WHEN MovementBoolean_PriceWithVAT.ValueData = TRUE OR COALESCE (MovementFloat_VATPercent.ValueData, 0) = 0
                       -- если цены с НДС или %НДС=0
                       THEN 1
                  WHEN MovementBoolean_PriceWithVAT.ValueData = FALSE
                       -- если цены c НДС
                       THEN (1 + MovementFloat_VATPercent.ValueData / 100)
             END
             )
           * CASE WHEN Movement.DescId = zc_Movement_PriceCorrective() THEN -1 ELSE 1 END
             AS NUMERIC (16, 4))

             -- ***минус
           -
             -- ***Сумма без НДС
             (
             CAST (
             CASE WHEN MovementBoolean_PriceWithVAT.ValueData = FALSE OR COALESCE (MovementFloat_VATPercent.ValueData, 0) = 0
                       -- если цены без НДС или %НДС=0
                       THEN 1
                  WHEN MovementBoolean_PriceWithVAT.ValueData = TRUE
                       -- если цены c НДС
                       THEN 1 / (1 + MovementFloat_VATPercent.ValueData / 100)
             END 
           * CASE WHEN MovementFloat_ChangePercent.ValueData <> 0
                       THEN CAST ( (1 + MovementFloat_ChangePercent.ValueData / 100) * COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC (16, 2))
                  ELSE COALESCE (MIFloat_Price.ValueData, 0)
             END / CASE WHEN MIFloat_CountForPrice.ValueData <> 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END
           * CASE WHEN Movement.DescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn(), zc_Movement_Income(), zc_Movement_ReturnOut())
                       THEN COALESCE (MIFloat_AmountPartner.ValueData, 0)
                  ELSE MIMaster.Amount
             END AS NUMERIC (16, 2)
             )
           * CASE WHEN Movement.DescId = zc_Movement_PriceCorrective() THEN -1 ELSE 1 END
             )
             ) :: TVarChar                                             AS PDV

             -- Сумма с НДС
           , CAST ((
             CAST (
             CASE WHEN MovementFloat_ChangePercent.ValueData <> 0
                       THEN CAST ( (1 + MovementFloat_ChangePercent.ValueData / 100) * COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC (16, 2))
                  ELSE COALESCE (MIFloat_Price.ValueData, 0)
             END / CASE WHEN MIFloat_CountForPrice.ValueData <> 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END
           * CASE WHEN Movement.DescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn(), zc_Movement_Income(), zc_Movement_ReturnOut())
                       THEN COALESCE (MIFloat_AmountPartner.ValueData, 0)
                  ELSE MIMaster.Amount
             END AS NUMERIC (16, 2))
           * CASE WHEN MovementBoolean_PriceWithVAT.ValueData = TRUE OR COALESCE (MovementFloat_VATPercent.ValueData, 0) = 0
                       -- если цены с НДС или %НДС=0
                       THEN 1
                  WHEN MovementBoolean_PriceWithVAT.ValueData = FALSE
                       -- если цены c НДС
                       THEN (1 + MovementFloat_VATPercent.ValueData / 100)
             END
             )
           * CASE WHEN Movement.DescId = zc_Movement_PriceCorrective() THEN -1 ELSE 1 END
             AS NUMERIC (16, 4)) :: TVarChar                           AS SummaPDV

           , ObjectHistory_JuridicalDetails_ViewByDate.INN             AS ClientINN
           , ObjectHistory_JuridicalDetails_ViewByDate.OKPO            AS ClientOKPO
           , CASE WHEN View_Contract_InvNumber.InfoMoneyId = zc_Enum_InfoMoney_30101() -- Готовая продукция
                       THEN 1
                  WHEN View_Contract_InvNumber.InfoMoneyId = zc_Enum_InfoMoney_30103() -- Хлеб
                       THEN 3

                  WHEN Movement.DescId IN (zc_Movement_Income(), zc_Movement_ReturnOut())
                       THEN 4
                  ELSE NULL
             END :: TVarChar                                           AS CLIENTKIND

           , MS_InvNumberPartner_Master.ValueData                      AS InvNalog
           , Movement.Id :: TVarChar                                   AS BillId
           , '' :: TVarChar                                            AS EKSPCODE
           , '' :: TVarChar                                            AS EKSPName
           , Object_Goods.Id :: TVarChar                               AS GoodsId
           , Object_GoodsKind.Id :: TVarChar                           AS PackId
           , Object_GoodsKind.ValueData                                AS PackName 
           , '' :: TVarChar                                            AS Doc1Date
           , '' :: TVarChar                                            AS Doc1Number
           , '' :: TVarChar                                            AS Doc2Date
           , '' :: TVarChar                                            AS Doc2Number

       FROM (SELECT Movement.*, Movement.OperDate AS OperDatePartner
             FROM Movement
             WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate 
               AND Movement.DescId IN (zc_Movement_PriceCorrective(), zc_Movement_TransferDebtOut(), zc_Movement_TransferDebtIn())
               AND Movement.StatusId = zc_Enum_Status_Complete()
            UNION 
             SELECT Movement.*, MovementDate_OperDatePartner.ValueData AS OperDatePartner
             FROM MovementDate AS MovementDate_OperDatePartner
                  INNER JOIN Movement ON Movement.Id = MovementDate_OperDatePartner.MovementId
                                     AND Movement.DescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn(), zc_Movement_Income(), zc_Movement_ReturnOut())
                                     AND Movement.StatusId = zc_Enum_Status_Complete()
             WHERE MovementDate_OperDatePartner.ValueData BETWEEN inStartDate AND inEndDate
               AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

            ) AS Movement
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId = CASE WHEN Movement.DescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn(), zc_Movement_PriceCorrective()
                                                                                                             , zc_Movement_Income(), zc_Movement_ReturnOut())
                                                                                           THEN zc_MovementLinkObject_Contract()
                                                                                      WHEN Movement.DescId IN (zc_Movement_TransferDebtOut())
                                                                                           THEN zc_MovementLinkObject_ContractTo()
                                                                                      WHEN Movement.DescId IN (zc_Movement_TransferDebtIn())
                                                                                           THEN zc_MovementLinkObject_ContractFrom()
                                                                                  END
            LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = MovementLinkObject_Contract.ObjectId
            INNER JOIN tmpInfoMoney ON tmpInfoMoney.InfoMoneyId = View_Contract_InvNumber.InfoMoneyId

            INNER JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                         ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                        AND MovementLinkObject_PaidKind.DescId = CASE WHEN Movement.DescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn(), zc_Movement_PriceCorrective()
                                                                                                             , zc_Movement_Income(), zc_Movement_ReturnOut())
                                                                                           THEN zc_MovementLinkObject_PaidKind()
                                                                                      WHEN Movement.DescId IN (zc_Movement_TransferDebtOut())
                                                                                           THEN zc_MovementLinkObject_PaidKindTo()
                                                                                      WHEN Movement.DescId IN (zc_Movement_TransferDebtIn())
                                                                                           THEN zc_MovementLinkObject_PaidKindFrom()
                                                                                  END
                                        AND MovementLinkObject_PaidKind.ObjectId = inPaidKindId

            /*LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()*/
            LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                      ON MovementBoolean_PriceWithVAT.MovementId = Movement.Id
                                     AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
            LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                    ON MovementFloat_VATPercent.MovementId = Movement.Id
                                   AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
            LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                    ON MovementFloat_ChangePercent.MovementId =  Movement.Id
                                   AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Master
                                           ON MovementLinkMovement_Master.MovementId = Movement.Id
                                          AND MovementLinkMovement_Master.DescId = zc_MovementLinkMovement_Master()
            LEFT JOIN Movement AS Movement_DocumentMaster
                               ON Movement_DocumentMaster.Id = MovementLinkMovement_Master.MovementChildId
                              AND Movement_DocumentMaster.StatusId <> zc_Enum_Status_Erased()
            LEFT JOIN MovementString AS MS_InvNumberPartner_Master
                                     ON MS_InvNumberPartner_Master.MovementId = Movement_DocumentMaster.Id
                                    AND MS_InvNumberPartner_Master.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                         ON MovementLinkObject_Partner.MovementId = Movement.Id
                                        AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()

            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = CASE WHEN Movement.DescId IN (zc_Movement_Sale(), zc_Movement_ReturnOut())
                                                                                THEN MovementLinkObject_To.ObjectId
                                                                           WHEN Movement.DescId IN (zc_Movement_ReturnIn(), zc_Movement_Income())
                                                                                THEN MovementLinkObject_From.ObjectId
                                                                           ELSE MovementLinkObject_Partner.ObjectId
                                                                      END
            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                 ON ObjectLink_Partner_Juridical.ObjectId = Object_Partner.Id
                                AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
            LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate
                   ON ObjectHistory_JuridicalDetails_ViewByDate.JuridicalId = CASE WHEN Movement.DescId = zc_Movement_PriceCorrective()
                                                                                        THEN MovementLinkObject_From.ObjectId
                                                                                   WHEN Movement.DescId = zc_Movement_TransferDebtOut()
                                                                                        THEN MovementLinkObject_To.ObjectId
                                                                                   WHEN Movement.DescId = zc_Movement_TransferDebtIn()
                                                                                        THEN MovementLinkObject_From.ObjectId
                                                                                   ELSE ObjectLink_Partner_Juridical.ChildObjectId
                                                                              END
                  AND Movement.OperDate >= ObjectHistory_JuridicalDetails_ViewByDate.StartDate AND Movement.OperDate < ObjectHistory_JuridicalDetails_ViewByDate.EndDate  


            LEFT JOIN MovementItem AS MIMaster ON MIMaster.MovementId = Movement.Id
                                              AND MIMaster.DescId = zc_MI_Master()
                                              AND MIMaster.isErased = FALSE
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MIMaster.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                             ON MILinkObject_GoodsKind.MovementItemId = MIMaster.Id
                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                            AND View_Contract_InvNumber.InfoMoneyId = zc_Enum_InfoMoney_30101() -- Готовая продукция
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                 ON ObjectLink_Goods_InfoMoney.ObjectId = MIMaster.ObjectId
                                AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
            LEFT JOIN Object_GoodsByGoodsKind_View ON Object_GoodsByGoodsKind_View.GoodsId = MIMaster.ObjectId
                                                  AND Object_GoodsByGoodsKind_View.GoodsKindId = MILinkObject_GoodsKind.ObjectId
                                                  -- AND ObjectLink_Goods_InfoMoney.ChildObjectId IN (zc_Enum_InfoMoney_20901(), zc_Enum_InfoMoney_30101(), zc_Enum_InfoMoney_30201()) -- Ирна AND Доходы + Продукция + Готовая продукция AND Доходы + Мясное сырье + Мясное сырье
  
            LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                        ON MIFloat_AmountPartner.MovementItemId = MIMaster.Id
                                       AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                        ON MIFloat_Price.MovementItemId = MIMaster.Id
                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()
            LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                        ON MIFloat_CountForPrice.MovementItemId = MIMaster.Id
                                        AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

      WHERE /*Movement.OperDate BETWEEN inStartDate AND inEndDate 
        AND Movement.DescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn(), zc_Movement_PriceCorrective(), zc_Movement_TransferDebtOut(), zc_Movement_TransferDebtIn())
        AND Movement.StatusId = zc_Enum_Status_Complete()
        AND */ /*(View_Contract_InvNumber.InfoMoneyId = inInfoMoneyId OR COALESCE (inInfoMoneyId, 0) = 0)
        AND (MovementLinkObject_PaidKind.ObjectId = inPaidKindId OR COALESCE (inPaidKindId, 0) = 0)
        AND */0 <> CASE WHEN Movement.DescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn(), zc_Movement_Income(), zc_Movement_ReturnOut())
                           THEN COALESCE (MIFloat_AmountPartner.ValueData, 0)
                      ELSE MIMaster.Amount
                 END
     ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_1C_Load (TDateTime, TDateTime, Integer, Integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 20.07.14                                        * add zc_Movement_PriceCorrective
 02.06.14                                        * add isErased = FALSE
 30.05.14                                        * add 0 <> 
 19.05.14                                        * all
 14.05.14                         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_1C_Load (inStartDate:= '06.06.2015', inEndDate:= '06.06.2015', inInfoMoneyId:= zc_Enum_InfoMoney_30201(), inPaidKindId:= 3, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_Movement_1C_Load (inStartDate:= '06.06.2015', inEndDate:= '06.06.2015', inInfoMoneyId:= zc_Enum_InfoMoney_30101(), inPaidKindId:= 3, inSession:= zfCalc_UserAdmin()) AS a WHERE InvNumber = '233695'
