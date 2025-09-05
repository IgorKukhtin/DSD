-- Function: gpSelect_Movement_VN_csv(Integer, tvarchar)

DROP FUNCTION IF EXISTS gpSelect_Movement_VN_csv (TDateTime, TDateTime, TVarChar, tvarchar);
DROP FUNCTION IF EXISTS gpSelect_Movement_VN_csv (TDateTime, TDateTime, Boolean, TVarChar, tvarchar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_VN_csv(
    IN inStartDate          TDateTime , --
    IN inEndDate            TDateTime , --
    IN inIsPartnerDate      Boolean   ,
    IN inFileName           TVarChar  ,
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS TABLE (RowData TBlob)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbFileName TVarChar;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Email_Send());
     vbUserId := lpGetUserBySession (inSession);


/*
в шапке
ПН;Номер;Дата у пок;Общая сумма без ндс;НДС; сумма с ндс ;ЕДРПОУ АЛАН;  1или 2 - форма оплаты где 1-бн и 2 - нал
окпо контрагента, потом окпо отправителя

в строчной части будет
Номер п/п;Товар;Код;Вид упаковки;Код вида;Количество;Цена без ндс;Сумма без ндс

Например
ПН;45646;20250808;10000.20;348483738;1
1;Колбаса;221;Флоу;129;100.2;50.00;5010.00
2;Колбаса;222;Флоу;129;100.2;50.00;5010.00
ПН;42646;20250809;10000.20;348483738;1
1;Колбаса;221;Флоу;129;100.2;50.00;5010.00
2;Колбаса;222;Флоу;129;100.2;50.00;5010.00

*/


     -- !!!Формат CSV

     -- первая строчка CSV  - Шапка / строки
     -- INSERT INTO _Result(RowData)
     --
     -- Результат
     RETURN QUERY
        WITH
        tmpMovement AS (SELECT Movement.*
                        FROM Movement
                             INNER JOIN MovementString AS MovementString_FileName
                                                       ON MovementString_FileName.MovementId = Movement.Id
                                                      AND MovementString_FileName.DescId = zc_MovementString_FileName()
                                                      AND MovementString_FileName.ValueData = inFileName
                        WHERE inIsPartnerDate = FALSE
                          AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                          AND Movement.DescId = zc_Movement_Sale()
                          AND Movement.StatusId <> zc_Enum_Status_Erased()
                       UNION ALL
                        SELECT Movement.*
                        FROM MovementDate AS MovementDate_OperDatePartner
                             JOIN Movement ON Movement.Id = MovementDate_OperDatePartner.MovementId AND Movement.DescId = zc_Movement_Sale()
                                          AND Movement.StatusId <> zc_Enum_Status_Erased()
                             INNER JOIN MovementString AS MovementString_FileName
                                                       ON MovementString_FileName.MovementId = Movement.Id
                                                      AND MovementString_FileName.DescId = zc_MovementString_FileName()
                                                      AND MovementString_FileName.ValueData = inFileName
                        WHERE inIsPartnerDate = TRUE
                          AND MovementDate_OperDatePartner.ValueData BETWEEN inStartDate AND inEndDate
                          AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                        --LIMIT 3
                        )
           , tmpMovementDate AS (SELECT MovementDate.*
                                 FROM MovementDate
                                 WHERE MovementDate.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                   AND MovementDate.DescId IN ( zc_MovementDate_OperDatePartner()
                                                              )
                                 )
           , tmpMovementFloat AS (SELECT MovementFloat.*
                                  FROM MovementFloat
                                  WHERE MovementFloat.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                    AND MovementFloat.DescId IN (zc_MovementFloat_TotalSummMVAT()
                                                               , zc_MovementFloat_TotalSummPVAT()
                                                               , zc_MovementFloat_VATPercent()
                                                                )
                                 )

           , tmpMLO AS (SELECT MovementLinkObject.*
                        FROM MovementLinkObject
                        WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                          AND MovementLinkObject.DescId IN (zc_MovementLinkObject_PaidKind()
                                                          , zc_MovementLinkObject_To()
                                                          , zc_MovementLinkObject_Contract()
                                                          , zc_MovementLinkObject_From()
                                                           )
                        )
           , tmpContract_InvNumber AS (SELECT Object_Contract_InvNumber_Sale_View.*
                                       FROM Object_Contract_InvNumber_Sale_View
                                       WHERE Object_Contract_InvNumber_Sale_View.ContractId IN (SELECT DISTINCT tmpMLO.ObjectId FROM tmpMLO WHERE tmpMLO.DescId = zc_MovementLinkObject_Contract())
                                       )

           , tmpMovementBoolean AS (SELECT MovementBoolean.*
                                    FROM MovementBoolean
                                    WHERE MovementBoolean.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                      AND MovementBoolean.DescId IN (zc_MovementBoolean_PriceWithVAT()
                                                                   )
                                    )

          , tmpJuridical AS (SELECT ObjectLink_Partner_Juridical.ObjectId AS PartnerId
                                  , Object_JuridicalTo.*
                             FROM ObjectLink AS ObjectLink_Partner_Juridical
                                  LEFT JOIN Object AS Object_JuridicalTo ON Object_JuridicalTo.Id = ObjectLink_Partner_Juridical.ChildObjectId
                             WHERE ObjectLink_Partner_Juridical.ObjectId IN (SELECT DISTINCT tmpMLO.ObjectId FROM tmpMLO WHERE tmpMLO.DescId = zc_MovementLinkObject_To())
                               AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                             )
           --, tmpContract_InvNumber AS (SELECT * FROM Object_Contract_InvNumber_Sale_View)
           , tmpJuridicalDetails AS (SELECT * FROM ObjectHistory_JuridicalDetails_View WHERE ObjectHistory_JuridicalDetails_View.JuridicalId IN (SELECT DISTINCT tmpJuridical.Id FROM tmpJuridical))


           , tmpMov_rez AS (SELECT Movement.Id
                                 , Movement.InvNumber
                                 , COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) AS OperDatePartner
                                 , MovementFloat_TotalSummMVAT.ValueData AS TotalSummMVAT
                                 , (COALESCE (MovementFloat_TotalSummPVAT.ValueData,0) - COALESCE (MovementFloat_TotalSummMVAT.ValueData,0) ) AS TotalSummVat
                                 , MovementFloat_TotalSummPVAT.ValueData AS TotalSummPVAT
                                 --, 348483738 AS OKPO
                                 , ObjectHistory_JuridicalDetails_to.OKPO    AS OKPO_to --
                                 , ObjectHistory_JuridicalDetails_from.OKPO  AS OKPO_from--
                                 , CASE WHEN MovementLinkObject_PaidKind.ObjectId = zc_Enum_PaidKind_FirstForm() THEN 1 ELSE 2 END AS PaidKind

                                 , MovementBoolean_PriceWithVAT.ValueData         AS PriceWithVAT
                                 , MovementFloat_VATPercent.ValueData             AS VATPercent

                                 , tmpContract_InvNumber.InfoMoneyName            AS InfoMoneyName
                                 , ObjectString_Address.ValueData                 AS Address_to

                            FROM tmpMovement AS Movement
                                     LEFT JOIN tmpMovementBoolean AS MovementBoolean_PriceWithVAT
                                                                  ON MovementBoolean_PriceWithVAT.MovementId =  Movement.Id
                                                                 AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()

                                     LEFT JOIN tmpMovementDate AS MovementDate_OperDatePartner
                                                               ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                                              AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

                                     LEFT JOIN tmpMovementFloat AS MovementFloat_TotalSummMVAT
                                                                ON MovementFloat_TotalSummMVAT.MovementId =  Movement.Id
                                                               AND MovementFloat_TotalSummMVAT.DescId = zc_MovementFloat_TotalSummMVAT()
                                     LEFT JOIN tmpMovementFloat AS MovementFloat_TotalSummPVAT
                                                                ON MovementFloat_TotalSummPVAT.MovementId =  Movement.Id
                                                               AND MovementFloat_TotalSummPVAT.DescId = zc_MovementFloat_TotalSummPVAT()

                                     LEFT JOIN tmpMovementFloat AS MovementFloat_VATPercent
                                                                ON MovementFloat_VATPercent.MovementId =  Movement.Id
                                                               AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()

                                     LEFT JOIN tmpMLO AS MovementLinkObject_PaidKind
                                                      ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                                     AND MovementLinkObject_PaidKind.DescId     = zc_MovementLinkObject_PaidKind()
                                     LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId
                                                                        -- ???
                                                                        AND Object_PaidKind.DescId = zc_Object_PaidKind()

                                     LEFT JOIN tmpMLO AS MovementLinkObject_Contract
                                                      ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                     AND MovementLinkObject_Contract.DescId    = zc_MovementLinkObject_Contract()
                                     LEFT JOIN tmpContract_InvNumber ON tmpContract_InvNumber.ContractId = MovementLinkObject_Contract.ObjectId

                                     LEFT JOIN tmpMLO AS MovementLinkObject_To
                                                      ON MovementLinkObject_To.MovementId = Movement.Id
                                                     AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                                     LEFT JOIN ObjectString AS ObjectString_Address
                                                            ON ObjectString_Address.ObjectId = MovementLinkObject_To.ObjectId
                                                           AND ObjectString_Address.DescId   = zc_ObjectString_Partner_Address()

                                     LEFT JOIN tmpJuridical AS Object_Juridical_to ON Object_Juridical_to.PartnerId = MovementLinkObject_To.ObjectId
                                     LEFT JOIN tmpJuridicalDetails AS ObjectHistory_JuridicalDetails_to ON ObjectHistory_JuridicalDetails_to.JuridicalId = Object_Juridical_to.Id

                                     LEFT JOIN tmpMLO AS MovementLinkObject_From
                                                      ON MovementLinkObject_From.MovementId = Movement.Id
                                                     AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                                     LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                                          ON ObjectLink_Unit_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                                                         AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                                     LEFT JOIN ObjectHistory_JuridicalDetails_View AS ObjectHistory_JuridicalDetails_from ON ObjectHistory_JuridicalDetails_from.JuridicalId = ObjectLink_Unit_Juridical.ChildObjectId
                               )


           , tmpMI AS (SELECT MovementItem.*
                       FROM MovementItem
                       WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                         AND MovementItem.DescId = zc_MI_Master()
                         AND MovementItem.isErased = FALSE
                       )

           , tmpMILinkObject_GoodsKind AS (SELECT MILinkObject_GoodsKind.*
                                           FROM MovementItemLinkObject AS MILinkObject_GoodsKind
                                           WHERE MILinkObject_GoodsKind.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                             AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                          )
           , tmpMIFloat AS (SELECT MovementItemFloat.*
                            FROM MovementItemFloat
                            WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                              AND MovementItemFloat.DescId IN (zc_MIFloat_Price(), zc_MIFloat_AmountPartner())
                           )

           , tmpMI_rez AS (SELECT MovementItem.MovementId
                                , ROW_NUMBER () OVER (PARTITION BY MovementItem.MovementId ORDER BY MovementItem.Id) AS Ord
                                , Object_Goods.ValueData      AS GoodsName
                                , Object_Goods.ObjectCode     AS GoodsCOde
                                , Object_GoodsKind.ValueData  AS GoodsKindName
                                , Object_GoodsKind.ObjectCode AS GoodsKindCOde
                                , MovementItem.Amount         AS Amount
                                , MIFloat_AmountPartner.ValueData AS AmountPartner
                                , MIFloat_Price.ValueData     AS Price      --
                           FROM tmpMI AS MovementItem
                                LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

                                LEFT JOIN tmpMILinkObject_GoodsKind AS MILinkObject_GoodsKind
                                                                 ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

                                LEFT JOIN tmpMIFloat AS MIFloat_Price
                                                            ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                           AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                LEFT JOIN tmpMIFloat AS MIFloat_AmountPartner
                                                     ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                    AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                           )


           , tmpData AS (SELECT Movement.Id AS MovementId
                              , Movement.InvNumber
                              , zfConvert_DateToStringY (Movement.OperDatePartner) AS OperDatePartner
                              , Movement.TotalSummPVAT
                              , Movement.TotalSummVat
                              , Movement.TotalSummMVAT
                              , Movement.OKPO_to
                              , Movement.OKPO_from
                              , Movement.PaidKind
                                --
                              , Movement.InfoMoneyName
                              , Movement.Address_to
                              --
                              , 0 AS Ord
                              , '' AS GoodsName
                              , 0 AS GoodsCode
                              , '' AS GoodsKindName
                              , 0 AS GoodsKindCode
                              , 0 AS AmountPartner
                              , 0 AS Price_mi
                                -- Без НДс
                              , 0 AS Price
                                -- сумма без НДС
                              , 0 AS SummPVAT

                         FROM tmpMov_rez AS Movement

                        UNION ALL
                         SELECT tmpMI.MovementId
                              , '' AS InvNumber
                              , '' AS OperDatePartner
                              , 0  AS TotalSummPVAT
                              , 0  AS TotalSummVat
                              , 0  AS TotalSummMVAT
                              , '' AS OKPO_to
                              , '' AS OKPO_from
                              , 0  AS PaidKind
                              , '' AS InfoMoneyName
                              , '' AS Address_to
                              --
                              , tmpMI.Ord
                              , tmpMI.GoodsName
                              , tmpMI.GoodsCOde
                              , tmpMI.GoodsKindName
                              , tmpMI.GoodsKindCOde
                              , tmpMI.AmountPartner
                              , tmpMI.Price AS Price_mi
                                -- Без НДс
                              , CASE WHEN Movement.PriceWithVAT = FALSE OR Movement.VATPercent = 0 THEN tmpMI.Price ELSE tmpMI.Price / Movement.VATPercent END AS Price
                                -- сумма без НДС
                              , (tmpMI.AmountPartner * CASE WHEN Movement.PriceWithVAT = FALSE OR Movement.VATPercent = 0 THEN tmpMI.Price ELSE tmpMI.Price / Movement.VATPercent END) AS SummPVAT

                         FROM tmpMI_rez AS tmpMI
                              LEFT JOIN tmpMov_rez AS Movement ON Movement.Id = tmpMI.MovementId
                         )
           -- Результат
           SELECT CASE WHEN tmpData.Ord = 0
                       THEN 'ПН;'||tmpData.InvNumber
                            ||';'||tmpData.OperDatePartner
                            ||';'||CAST (tmpData.TotalSummMVAT AS NUMERIC (16,2)) ::TVarChar
                            ||';'||CAST (tmpData.TotalSummVat AS NUMERIC (16,2)) ::TVarChar
                            ||';'||CAST (tmpData.TotalSummPVAT AS NUMERIC (16,2)) ::TVarChar
                            ||';'||tmpData.OKPO_to
                            ||';'||tmpData.OKPO_from
                            ||';'||tmpData.PaidKind
                            ||';'||tmpData.Address_to
                            ||';'||tmpData.InfoMoneyName
                            ||CASE WHEN vbUserId = 5 THEN ';'|| (ROW_NUMBER() OVER (ORDER BY tmpData.MovementId, tmpData.Ord)) :: TVarChar ELSE '' END
                       ELSE
                                   tmpData.Ord ::TVarChar
                            ||';'||tmpData.GoodsName
                            ||';'||tmpData.GoodsCOde
                            ||';'||tmpData.GoodsKindName
                            ||';'||tmpData.GoodsKindCOde
                            ||';'||CAST (tmpData.AmountPartner AS NUMERIC (16,4)) ::TVarChar
                            ||';'||CAST (tmpData.Price AS NUMERIC (16,2)) ::TVarChar
                            ||';'||CAST (tmpData.SummPVAT AS NUMERIC (16,2)) ::TVarChar
                  END :: TBlob AS RowData
           FROM tmpData
           ORDER BY tmpData.MovementId
                   ,tmpData.Ord
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.08.25         *
 */

-- тест
-- SELECT * FROM gpSelect_Movement_VN_csv (inStartDate:= '08.08.2025', inEndDate:= '08.08.2025', inFileName:= 'VN_08.08.2025_08.08.2025 08.08.2025 17:39', inSession:= zfCalc_UserAdmin()) -- zc_Enum_ExportKind_Mida35273055()
-- SELECT * FROM gpSelect_Movement_VN_csv (inStartDate:= '08.08.2025', inEndDate:= '08.08.2025', inFileName:= 'VN_08.08.2025_08.08.2025 08.08.2025 20_05 К. К. Климентьев', inSession:= zfCalc_UserAdmin()) -- zc_Enum_ExportKind_Mida35273055()
-- SELECT * FROM gpSelect_Movement_VN_csv(inStartDate := ('01.09.2025')::TDateTime , inEndDate := ('04.09.2025')::TDateTime , inIsPartnerDate := 'true' , inFileName := 'VN_01.09.2025_04.09.2025 04.09.2025 11_43 А. А. Залозна' ,  inSession := '378f6845-ef70-4e5b-aeb9-45d91bd5e82e')
