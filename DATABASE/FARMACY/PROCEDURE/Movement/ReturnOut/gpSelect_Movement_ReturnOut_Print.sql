-- Function: gpSelect_Movement_ReturnOut_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_ReturnOut_Print (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_ReturnOut_Print(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_ReturnOut());
    vbUserId:= inSession;

    OPEN Cursor1 FOR
    WITH 
    tmpBankAccount AS (SELECT tmp.JuridicalId
                                , MAX (tmp.Id) AS Id
                                , tmp.BankAccount
                                , tmp.BankName
                                , tmp.MFO
                           FROM (SELECT ObjectLink_Juridical.ChildObjectId AS JuridicalId
                                      , Object_BankAccount.Id
                                      , Object_BankAccount.ValueData AS BankAccount
                                      , Object_Bank.ValueData AS BankName
                                      , ObjectString_MFO.ValueData AS MFO
                                 FROM Object AS Object_BankAccount
                                    LEFT JOIN ObjectLink AS ObjectLink_Juridical
                                                         ON ObjectLink_Juridical.ObjectId = Object_BankAccount.Id
                                                        AND ObjectLink_Juridical.DescId = zc_ObjectLink_BankAccount_Juridical()
                                    LEFT JOIN ObjectLink AS ObjectLink_Bank
                                                         ON ObjectLink_Bank.ObjectId = Object_BankAccount.Id
                                                        AND ObjectLink_Bank.DescId = zc_ObjectLink_BankAccount_Bank()
                                    LEFT JOIN Object AS Object_Bank ON Object_Bank.Id = ObjectLink_Bank.ChildObjectId
                                    LEFT JOIN ObjectString AS ObjectString_MFO
                                                           ON ObjectString_MFO.ObjectId = Object_Bank.Id
                                                          AND ObjectString_MFO.DescId = zc_ObjectString_Bank_MFO()
                                 WHERE Object_BankAccount.DescId = zc_object_BankAccount()
                                 UNION
                                 SELECT ObjectLink_Juridical.ChildObjectId AS JuridicalId
                                      , Object_BankAccount.Id
                                      , OS_BankAccount_CBAccount.ValueData AS BankAccount
                                      , Object_Bank.ValueData AS BankName
                                      , ObjectString_MFO.ValueData AS MFO
                                 FROM Object AS Object_BankAccount
                                    LEFT JOIN ObjectLink AS ObjectLink_Juridical
                                                         ON ObjectLink_Juridical.ObjectId = Object_BankAccount.Id
                                                        AND ObjectLink_Juridical.DescId = zc_ObjectLink_BankAccount_Juridical()
                                    LEFT JOIN ObjectLink AS ObjectLink_Bank
                                                         ON ObjectLink_Bank.ObjectId = Object_BankAccount.Id
                                                        AND ObjectLink_Bank.DescId = zc_ObjectLink_BankAccount_Bank()
                                    LEFT JOIN Object AS Object_Bank ON Object_Bank.Id = ObjectLink_Bank.ChildObjectId
                                    LEFT JOIN ObjectString AS ObjectString_MFO
                                                           ON ObjectString_MFO.ObjectId = Object_Bank.Id
                                                          AND ObjectString_MFO.DescId = zc_ObjectString_Bank_MFO()
                                    LEFT JOIN ObjectString AS OS_BankAccount_CBAccount
                                                           ON OS_BankAccount_CBAccount.ObjectId = Object_BankAccount.Id
                                                          AND OS_BankAccount_CBAccount.DescId = zc_ObjectString_BankAccount_CBAccount()
                                 WHERE Object_BankAccount.DescId = zc_object_BankAccount()
                                 ) AS tmp
                           GROUP BY tmp.JuridicalId
                                  , tmp.BankAccount
                                  , tmp.BankName
                                  , tmp.MFO
                           )

        SELECT
            Movement_ReturnOut.Id
          , Movement_ReturnOut.InvNumber
          , Movement_ReturnOut.OperDate
          , Movement_ReturnOut.toId
          , ObjectHistory_ToDetails.FullName                  AS ToName
          , Movement_ReturnOut.IncomeInvNumber
          , Movement_ReturnOut.IncomeOperDate
          , Movement_ReturnOut.JuridicalName
          , Movement_ReturnOut.FromName
          , Movement_ReturnOut.ReturnTypeName
          , Movement_ReturnOut.LegalAddressName
          , Movement_ReturnOut.ActualAddressName
          , Movement_ReturnOut.TotalSummMVAT
          , Movement_ReturnOut.TotalSumm
          , (Movement_ReturnOut.TotalSumm - Movement_ReturnOut.TotalSummMVAT) AS TotalSummVAT
          , Movement_ReturnOut.TotalCount

          , ObjectHistory_JuridicalDetails.FullName           AS JuridicalFullName
          , ObjectHistory_JuridicalDetails.JuridicalAddress   AS JuridicalAddress
          , ObjectHistory_JuridicalDetails.OKPO
          , ObjectHistory_JuridicalDetails.AccounterName
          , ObjectHistory_JuridicalDetails.BankAccount
          , tmpBankAccount.BankName  ::TVarChar
          , tmpBankAccount.MFO       ::TVarChar
         
          , ObjectHistory_ToDetails.OKPO               AS OKPO_To
          , ObjectHistory_ToDetails.JuridicalAddress   AS JuridicalAddress_to
          , ObjectHistory_ToDetails.AccounterName      AS AccounterName_To
          , ObjectHistory_ToDetails.INN                AS INN_To
          , ObjectHistory_ToDetails.NumberVAT          AS NumberVAT_To
          , ObjectHistory_ToDetails.BankAccount        AS BankAccount_To
          , ObjectHistory_ToDetails.Phone              AS Phone_To
          , ObjectHistory_ToDetails.Phone              AS License
          , tmpBankAccount_To.BankName  ::TVarChar AS BankName_To
          , tmpBankAccount_To.MFO       ::TVarChar AS MFO_To

          , ObjectString_Unit_Address.ValueData               AS Address_From
          , ObjectHistory_ToDetails.FullName                  AS JuridicalFullName_To
        FROM Movement_ReturnOut_View AS Movement_ReturnOut
            LEFT JOIN gpSelect_ObjectHistory_JuridicalDetails(inJuridicalid := Movement_ReturnOut.JuridicalId, inFullName := '', inOKPO := '', inSession := inSession) AS ObjectHistory_JuridicalDetails ON 1=1
            LEFT JOIN gpSelect_ObjectHistory_JuridicalDetails(inJuridicalid := Movement_ReturnOut.ToId, inFullName := '', inOKPO := '', inSession := inSession) AS ObjectHistory_ToDetails ON 1=1
            LEFT JOIN ObjectString AS ObjectString_Unit_Address
                                   ON ObjectString_Unit_Address.ObjectId = Movement_ReturnOut.FromId
                                  AND ObjectString_Unit_Address.DescId = zc_ObjectString_Unit_Address()

           LEFT JOIN tmpBankAccount ON tmpBankAccount.JuridicalId = Movement_ReturnOut.JuridicalId
                                   AND tmpBankAccount.BankAccount = ObjectHistory_JuridicalDetails.BankAccount

           LEFT JOIN tmpBankAccount AS tmpBankAccount_To
                                    ON tmpBankAccount_To.JuridicalId = Movement_ReturnOut.JuridicalId
                                   AND tmpBankAccount_To.BankAccount = ObjectHistory_ToDetails.BankAccount
        WHERE Movement_ReturnOut.Id = inMovementId;
    RETURN NEXT Cursor1;


    OPEN Cursor2 FOR
    WITH 
    tmpMovement_ReturnOut AS (
        SELECT
            Movement_ReturnOut.Id
          , Movement_ReturnOut.ToId
        FROM Movement_ReturnOut_View AS Movement_ReturnOut
        WHERE Movement_ReturnOut.Id = inMovementId),
    tmpMI AS (SELECT MI_ReturnOut.*
                              
                   , COALESCE (Object_Goods_Juridical.Name, MI_ReturnOut.GoodsName) AS JuridicalName 
                                                 
                   , Object_Goods.MorionCode
                    
                   , ROW_NUMBER() OVER (PARTITION BY MI_ReturnOut.Id ORDER BY Object_Goods_Juridical.Id) AS Ord

                 FROM
                     MovementItem_ReturnOut_View AS MI_ReturnOut

                     LEFT JOIN tmpMovement_ReturnOut ON 1 = 1

                     LEFT JOIN Object_Goods_Retail ON Object_Goods_Retail.Id = MI_ReturnOut.GoodsId
                     LEFT JOIN Object_Goods_Main AS Object_Goods ON Object_Goods.Id = Object_Goods_Retail.GoodsMainId
                     LEFT JOIN Object_Goods_Juridical AS Object_Goods_Juridical ON Object_Goods_Juridical.GoodsMainId = Object_Goods_Retail.GoodsMainId
                                                     AND Object_Goods_Juridical.JuridicalId = tmpMovement_ReturnOut.ToId


                 WHERE MI_ReturnOut.MovementId = inMovementId
                   AND MI_ReturnOut.isErased = FALSE)
    
        SELECT
            MI_ReturnOut.GoodsName
          , MI_ReturnOut.Amount
          , Object_Measure.ValueData AS MeasureName
          
          , MIDate_ExpirationDate.ValueData            AS ExpirationDate
          , MIString_PartionGoods.ValueData            AS PartionGoods
          , ObjectString_Goods_Maker.ValueData         AS MakerName
          
          , MI_ReturnOut.JuridicalName 
          
          , CASE WHEN COALESCE(MovementBoolean_PriceWithVAT.ValueData,FALSE) = TRUE 
                THEN MI_ReturnOut.Price
                ELSE ROUND(MI_ReturnOut.Price*(1+(ObjectFloat_NDSKind_NDS.ValueData/100)),2)
            END AS PriceWithVAT
          , CASE WHEN COALESCE(MovementBoolean_PriceWithVAT.ValueData,FALSE) = TRUE 
                THEN MI_ReturnOut.AmountSumm
                ELSE ROUND(MI_ReturnOut.AmountSumm*(1+(ObjectFloat_NDSKind_NDS.ValueData/100)),2)
            END AS SummaWithVAT
          , CASE WHEN COALESCE(MovementBoolean_PriceWithVAT.ValueData,FALSE) = FALSE
                THEN MI_ReturnOut.Price
                ELSE ROUND(MI_ReturnOut.Price/(1+(ObjectFloat_NDSKind_NDS.ValueData/100)),2)
            END AS Price
          , CASE WHEN COALESCE(MovementBoolean_PriceWithVAT.ValueData,FALSE) = FALSE
                THEN MI_ReturnOut.AmountSumm
                ELSE ROUND(MI_ReturnOut.AmountSumm/(1+(ObjectFloat_NDSKind_NDS.ValueData/100)),2)
            END AS Summa  

          , COALESCE(Object_ConditionsKeep.ValueData, '') ::TVarChar  AS ConditionsKeepName
          
          , MI_ReturnOut.MorionCode
          
        FROM
            tmpMI AS MI_ReturnOut

            LEFT OUTER JOIN ObjectLink AS ObjectLink_Goods_Measure
                                       ON ObjectLink_Goods_Measure.ObjectId = MI_ReturnOut.GoodsId
                                      AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT OUTER JOIN Object AS Object_Measure
                                   ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
            LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                      ON MovementBoolean_PriceWithVAT.MovementId =  MI_ReturnOut.MovementId
                                     AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
            LEFT JOIN MovementLinkObject AS MovementLinkObject_NDSKind
                                         ON MovementLinkObject_NDSKind.MovementId = MI_ReturnOut.MovementId
                                        AND MovementLinkObject_NDSKind.DescId = zc_MovementLinkObject_NDSKind()
            LEFT JOIN Object AS Object_NDSKind ON Object_NDSKind.Id = MovementLinkObject_NDSKind.ObjectId
            LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                  ON ObjectFloat_NDSKind_NDS.ObjectId = MovementLinkObject_NDSKind.ObjectId
                                 AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()
 
            -- данные из прихода 
            LEFT JOIN MovementItemDate AS MIDate_ExpirationDate
                                       ON MIDate_ExpirationDate.MovementItemId = MI_ReturnOut.ParentId
                                      AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()

            LEFT JOIN MovementItemString AS MIString_PartionGoods
                                         ON MIString_PartionGoods.MovementItemId = MI_ReturnOut.ParentId
                                        AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()  
                                        
            LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                             ON MILinkObject_Goods.MovementItemId = MI_ReturnOut.ParentId
                                            AND MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
            LEFT JOIN ObjectString AS ObjectString_Goods_Maker
                                  ON ObjectString_Goods_Maker.ObjectId = MILinkObject_Goods.ObjectId 
                                 AND ObjectString_Goods_Maker.DescId = zc_ObjectString_Goods_Maker()

        -- условия хранения
        LEFT JOIN ObjectLink AS ObjectLink_Goods_ConditionsKeep
                             ON ObjectLink_Goods_ConditionsKeep.ObjectId = MI_ReturnOut.GoodsId
                            AND ObjectLink_Goods_ConditionsKeep.DescId = zc_ObjectLink_Goods_ConditionsKeep()
        LEFT JOIN Object AS Object_ConditionsKeep ON Object_ConditionsKeep.Id = ObjectLink_Goods_ConditionsKeep.ChildObjectId

        WHERE MI_ReturnOut.Ord = 1;

    RETURN NEXT Cursor2;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_ReturnOut_Print (Integer,TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А
 13.01.20         *
 06.02.19         *
 14.04.16         *
 25.12.15                                                                       *
*/

-- SELECT * FROM gpSelect_Movement_ReturnOut_Print (inMovementId := 570596, inSession:= '5');
--select * from gpSelect_Movement_ReturnOut_Print(inMovementId := 12521745 ,  inSession := '3');

select * from gpSelect_Movement_ReturnOut_Print(inMovementId := 29784939 ,  inSession := '3');