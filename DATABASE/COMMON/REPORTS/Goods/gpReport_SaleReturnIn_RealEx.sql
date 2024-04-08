-- FunctiON: gpReport_SaleReturnIn_RealEx ()

DROP FUNCTION IF EXISTS gpReport_SaleReturnIn_RealEx (TDateTime, TDateTime, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_SaleReturnIn_RealEx (
    IN inStartDate           TDateTime ,  
    IN inEndDate             TDateTime ,
    IN inJuridicalId         Integer   , --
    IN inPartnerId           Integer   ,
    IN inGoodsId             Integer   ,
    IN inisMovement          Boolean   ,
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS TABLE (GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, GoodsKindId Integer, GoodsKindName TVarChar
             , Amount        TFloat  -- 
             , AmountReturn  TFloat  -- 
             , Price         TFloat  -- 
             , PriceReturn   TFloat  --
             , Summa         TFloat
             , SummaReturn   TFloat
             , isDiff        Boolean

             , JuridicalCode Integer, JuridicalName TVarChar
             , PartnerCode Integer, PartnerName TVarChar
             , ContractCode Integer, ContractName TVarChar
             
             , MovementId Integer, MovementItemId Integer
             , InvNumber TVarChar, InvNumberPartner TVarChar, OperDate TDateTime, OperDatePartner TDateTime
             , MovementId_ReturnIn Integer, InvNumber_ReturnIn TVarChar, OperDate_ReturnIn TDateTime
             )

AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

    -- Результат
    RETURN QUERY

    WITH 
         --контрагенты
         tmpPartner AS (SELECT inPartnerId AS PartnerId
                        WHERE COALESCE (inPartnerId,0) <> 0
                      UNION
                        SELECT ObjectLink_Partner_Juridical.ObjectId AS PartnerId
                        FROM ObjectLink AS ObjectLink_Partner_Juridical
                        WHERE COALESCE (inJuridicalId,0) <> 0 AND COALESCE (inPartnerId,0) = 0
                          AND ObjectLink_Partner_Juridical.ChildObjectId = inJuridicalId
                          AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                      UNION
                        SELECT Object_Partner.Id AS PartnerId
                        FROM Object AS Object_Partner
                        WHERE COALESCE (inJuridicalId,0) = 0 AND COALESCE (inPartnerId,0) = 0
                          AND Object_Partner.DescId = zc_Object_Partner()
                        )
                        
         -- Документы продажи
        , tmpMovement AS (SELECT Movement.Id        AS MovementId_Sale
                              , MovementLinkMovement_ReturnIn.MovementChildId AS MovementId_ReturnIn
                              , MovementLinkObject_To.ObjectId AS PartnerId
                              , MovementLinkObject_Contract.ObjectId AS ContractId
                         FROM Movement 
                              INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                            ON MovementLinkObject_To.MovementId = Movement.Id
                                                           AND MovementLinkObject_To.DescId = zc_MovementLinkObject_From()
                              INNER JOIN tmpPartner ON tmpPartner.PartnerId = MovementLinkObject_To.ObjectId
 
                              LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                           ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                          AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                              --берем только если договор RealEx = TRUE
                              INNER JOIN ObjectBoolean AS ObjectBoolean_Contract_RealEx
                                                       ON ObjectBoolean_Contract_RealEx.ObjectId = MovementLinkObject_Contract.ObjectId
                                                      AND ObjectBoolean_Contract_RealEx.DescId = zc_ObjectBoolean_Contract_RealEx()
                                                      AND COALESCE (ObjectBoolean_Contract_RealEx.ValueData,FALSE) = TRUE
                              -- связь с возвратом
                              LEFT JOIN MovementLinkMovement AS MovementLinkMovement_ReturnIn
                                                             ON MovementLinkMovement_ReturnIn.MovementId = Movement.Id
                                                            AND MovementLinkMovement_ReturnIn.DescId = zc_MovementLinkMovement_ReturnIn()
                         WHERE Movement.StatusId = zc_Enum_Status_Complete()
                           AND Movement.DescId = zc_Movement_Sale()
                           AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                         )

        -- строки док. продаж
      , tmpMI_Sale AS (SELECT MovementItem.MovementId
                            , MovementItem.Id AS MI_Id
                            , MovementItem.ObjectId AS GoodsId
                            , MovementItem.Amount
                       FROM MovementItem
                       WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovement.MovementId_Sale FROM tmpMovement)
                         AND MovementItem.DescId     = zc_MI_Master()
                         AND MovementItem.isErased   = FALSE
                         AND (MovementItem.ObjectId = inGoodsId OR inGoodsId = 0)
                       )
        -- строки док. возврата
      , tmpMI_Ret AS (SELECT MovementItem.MovementId
                           , MovementItem.Id AS MI_Id
                           , MovementItem.ObjectId AS GoodsId
                           , MovementItem.Amount
                      FROM MovementItem
                      WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovement.MovementId_ReturnIn FROM tmpMovement)
                        AND MovementItem.DescId     = zc_MI_Master()
                        AND MovementItem.isErased   = FALSE
                        AND (MovementItem.ObjectId = inGoodsId OR inGoodsId = 0)
                      )
      , tmpMIFloat AS (SELECT MovementItemFloat.*
                       FROM MovementItemFloat
                       WHERE MovementItemFloat.MovementItemId IN (SELECT tmpMI_Sale.MI_Id FROM tmpMI_Sale UNION SELECT tmpMI_Ret.MI_Id FROM tmpMI_Ret)
                         AND MovementItemFloat.DescId = zc_MIFloat_Price()
                       )
      , tmpMILO AS (SELECT MovementItemLinkObject.*
                    FROM MovementItemLinkObject
                    WHERE MovementItemLinkObject.MovementItemId IN (SELECT tmpMI_Sale.MI_Id FROM tmpMI_Sale UNION SELECT tmpMI_Ret.MI_Id FROM tmpMI_Ret)
                      AND MovementItemLinkObject.DescId = zc_MILinkObject_GoodsKind()
                    )
      , tmpData AS (SELECT tmp.MovementId_Sale
                         , tmp.MovementId_ReturnIn
                         , tmp.MovementItemId_Sale
                         , tmp.PartnerId
                         , tmp.ContractId
                         , tmp.GoodsId
                         , tmp.GoodsKindId
                         , tmp.Price
                         , tmp.PriceReturn
                         , SUM (tmp.Amount) AS Amount
                         , SUM (tmp.AmountReturn) AS AmountReturn
                    FROM (
                          SELECT CASE WHEN inisMovement = TRUE THEN tmpMovement.MovementId_Sale ELSE 0 END AS MovementId_Sale
                               , CASE WHEN inisMovement = TRUE THEN tmpMovement.MovementId_ReturnIn ELSE 0 END AS MovementId_ReturnIn
                               , CASE WHEN inisMovement = TRUE THEN MovementItem.MI_Id ELSE 0 END AS MovementItemId_Sale
                               , tmpMovement.PartnerId
                               , tmpMovement.ContractId
                               , MovementItem.GoodsId
                               , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                               , COALESCE (MIFloat_Price.ValueData, 0)         AS Price
                               , MovementItem.Amount
                               , 0 AS PriceReturn
                               , 0 AS AmountReturn
                          FROM tmpMovement
                              LEFT JOIN tmpMI_Sale AS MovementItem ON MovementItem.MovementId = tmpMovement.MovementId_Sale
      
                              LEFT JOIN tmpMILO AS MILinkObject_GoodsKind
                                                ON MILinkObject_GoodsKind.MovementItemId = MovementItem.MI_Id
                              LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                          ON MIFloat_Price.MovementItemId = MovementItem.MI_Id
                        UNION
                          SELECT CASE WHEN inisMovement = TRUE THEN tmpMovement.MovementId_Sale ELSE 0 END AS MovementId_Sale
                               , CASE WHEN inisMovement = TRUE THEN tmpMovement.MovementId_ReturnIn ELSE 0 END AS MovementId_ReturnIn
                               , 0 AS MovementItemId_Sale
                               , tmpMovement.PartnerId
                               , tmpMovement.ContractId
                               , MovementItem.GoodsId
                               , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                               , 0 AS Price
                               , 0 AS Amount
                               , COALESCE (MIFloat_Price.ValueData, 0) AS PriceReturn
                               , MovementItem.Amount AS AmountReturn
                          FROM tmpMovement
                              LEFT JOIN tmpMI_Ret AS MovementItem ON MovementItem.MovementId = tmpMovement.MovementId_ReturnIn
      
                              LEFT JOIN tmpMILO AS MILinkObject_GoodsKind
                                                ON MILinkObject_GoodsKind.MovementItemId = MovementItem.MI_Id
                              LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                          ON MIFloat_Price.MovementItemId = MovementItem.MI_Id
                          ) AS tmp
                    GROUP BY tmp.MovementId_Sale
                           , tmp.MovementId_ReturnIn
                           , tmp.MovementItemId_Sale
                           , tmp.PartnerId
                           , tmp.ContractId
                           , tmp.GoodsId
                           , tmp.GoodsKindId
                           , tmp.Price
                           , tmp.PriceReturn
                   )

    SELECT Object_Goods.Id                            AS GoodsId
         , Object_Goods.ObjectCode                    AS GoodsCode
         , Object_Goods.ValueData                     AS GoodsName
         , Object_GoodsKind.Id                        AS GoodsKindId
         , Object_GoodsKind.ValueData                 AS GoodsKindName
         
         , tmpData.Amount         ::tfloat 
         , tmpData.AmountReturn   ::tfloat 
         , tmpData.Price          ::tfloat
         , tmpData.PriceReturn    ::tfloat
         , (tmpData.Amount * tmpData.Price) ::TFloat AS Summa
         , (tmpData.AmountReturn * tmpData.PriceReturn) ::TFloat AS SummaReturn

         , CASE WHEN COALESCE (tmpData.Amount,0) <> COALESCE (tmpData.AmountReturn,0) OR  COALESCE (tmpData.Price,0) <> COALESCE (tmpData.PriceReturn,0)
                THEN TRUE
                ELSE FALSE
           END :: Boolean AS isDiff

         , Object_Juridical.ObjectCode     AS JuridicalCode
         , Object_Juridical.ValueData      AS JuridicalName

         , Object_Partner.ObjectCode    AS PartnerCode
         , Object_Partner.ValueData     AS PartnerName

         , Object_Contract.ObjectCode     AS ContractCode
         , Object_Contract.ValueData      AS ContractName

         , tmpData.MovementId_Sale                   AS MovementId
         , tmpData.MovementItemId_Sale               AS MovementItemId
         , Movement_Sale.InvNumber                   ::TVarChar AS InvNumber
         , MovementString_InvNumberPartner.ValueData ::TVarChar AS InvNumberPartner
         , Movement_Sale.Operdate                 ::TDateTime   AS Operdate
         , MovementDate_OperDatePartner.ValueData ::TDateTime   AS OperDatePartner

         , Movement_ReturnIn.Id                                 AS MovementId_ReturnIn
         , Movement_ReturnIn.InvNumber            ::TVarChar    AS InvNumber_ReturnIn
         , Movement_ReturnIn.Operdate             ::TDateTime   AS OperDate_ReturnIn

       FROM tmpData
          LEFT JOIN Movement AS Movement_Sale ON Movement_Sale.Id = tmpData.MovementId_Sale
          LEFT JOIN Movement AS Movement_ReturnIn ON Movement_ReturnIn.Id = tmpData.MovementId_ReturnIn

          LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = tmpData.PartnerId
          LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = tmpData.ContractId

          LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                               ON ObjectLink_Partner_Juridical.ObjectId = Object_Partner.Id
                              AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
          LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Partner_Juridical.ChildObjectId
         
          LEFT JOIN Object AS Object_Goods on Object_Goods.Id = tmpData.GoodsId
          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpData.GoodsKindId
          
          LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                   ON MovementString_InvNumberPartner.MovementId = Movement_Sale.Id 
                                  AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
          LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                 ON MovementDate_OperDatePartner.MovementId = Movement_Sale.Id
                                AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

              ;
       
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.03.22         *
*/

-- тест
-- SELECT * FROM gpReport_SaleReturnIn_RealEx(inStartDate := ('22.03.2022')::TDateTime , inEndDate := ('22.03.2022')::TDateTime , inJuridicalId := 0 , inPartnerId := 0 , inGoodsId := 0 , inisMovement := FALSE ,  inSession := '5');