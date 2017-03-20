-- Function: gpSelect_Movement_Sale_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_Sale_Print (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Sale_Print(
    IN inMovementId                 Integer  , -- ключ Документа
    IN inSession                    TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Check());
    vbUserId:= inSession;

    OPEN Cursor1 FOR
        SELECT
             Movement.Id 
           , Movement.InvNumber
           , Movement.OperDate
           , MovementFloat_TotalCount.ValueData   AS TotalCount
           , MovementFloat_TotalSumm.ValueData    AS TotalSumm
           , MovementFloat_TotalSummChangePercent.ValueData  AS TotalSummChangePercent
           , Object_Unit.ValueData                AS UnitName
           , Object_JuridicalFrom.ValueData       AS JuridicalFromName

           , ObjectHistory_JuridicalDetails.FullName AS JuridicalFullName
           , ObjectHistory_JuridicalDetails.JuridicalAddress
           , ObjectHistory_JuridicalDetails.OKPO
           , ObjectHistory_JuridicalDetails.AccounterName
           , ObjectHistory_JuridicalDetails.INN
           , ObjectHistory_JuridicalDetails.NumberVAT
           , ObjectHistory_JuridicalDetails.BankAccount
           , ObjectHistory_JuridicalDetails.Phone

           , 'Чек' :: TVarChar                    AS ContractName
           , 'Основний склад' :: TVarChar         AS StorageName

           , MovementDate_OperDateSP.ValueData               AS OperDateSP
           , MovementString_InvNumberSP.ValueData            AS InvNumberSP

           , Object_MedicSP.ValueData                        AS MedicSPName
           , Object_MemberSP.ValueData                       AS MemberSPName
           , Object_PartnerMedical.ValueData                 AS PartnerMedicalName
           , Object_GroupMemberSP.ValueData                  AS GroupMemberSPName

        FROM Movement 
            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummChangePercent
                                    ON MovementFloat_TotalSummChangePercent.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummChangePercent.DescId = zc_MovementFloat_TotalSummChangePercent()

            LEFT JOIN MovementString AS MovementString_InvNumberSP
                                     ON MovementString_InvNumberSP.MovementId = Movement.Id
                                    AND MovementString_InvNumberSP.DescId = zc_MovementString_InvNumberSP()

            LEFT JOIN MovementDate AS MovementDate_OperDateSP
                                   ON MovementDate_OperDateSP.MovementId = Movement.Id
                                  AND MovementDate_OperDateSP.DescId = zc_MovementDate_OperDateSP()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                 ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit.Id
                                AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Unit_Juridical.ChildObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                         ON MovementLinkObject_Juridical.MovementId = Movement.Id
                                        AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
            LEFT JOIN Object AS Object_JuridicalFrom ON Object_JuridicalFrom.Id = MovementLinkObject_Juridical.ObjectId
       
            LEFT JOIN MovementLinkObject AS MovementLinkObject_PartnerMedical
                                         ON MovementLinkObject_PartnerMedical.MovementId = Movement.Id
                                        AND MovementLinkObject_PartnerMedical.DescId = zc_MovementLinkObject_PartnerMedical()
            LEFT JOIN Object AS Object_PartnerMedical ON Object_PartnerMedical.Id = MovementLinkObject_PartnerMedical.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_GroupMemberSP
                                         ON MovementLinkObject_GroupMemberSP.MovementId = Movement.Id
                                        AND MovementLinkObject_GroupMemberSP.DescId = zc_MovementLinkObject_GroupMemberSP()
            LEFT JOIN Object AS Object_GroupMemberSP ON Object_GroupMemberSP.Id = MovementLinkObject_GroupMemberSP.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_MedicSP
                                         ON MovementLinkObject_MedicSP.MovementId = Movement.Id
                                        AND MovementLinkObject_MedicSP.DescId = zc_MovementLinkObject_MedicSP()
            LEFT JOIN Object AS Object_MedicSP ON Object_MedicSP.Id = MovementLinkObject_MedicSP.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_MemberSP
                                         ON MovementLinkObject_MemberSP.MovementId = Movement.Id
                                        AND MovementLinkObject_MemberSP.DescId = zc_MovementLinkObject_MemberSP()
            LEFT JOIN Object AS Object_MemberSP ON Object_MemberSP.Id = MovementLinkObject_MemberSP.ObjectId

            LEFT JOIN gpSelect_ObjectHistory_JuridicalDetails(injuridicalid := Object_Juridical.Id, inFullName := '', inOKPO := '', inSession := inSession) AS ObjectHistory_JuridicalDetails ON 1=1

        WHERE Movement.Id = inMovementId
;

    RETURN NEXT Cursor1;


    OPEN Cursor2 FOR
    
    SELECT
        MovementItem.Id                    AS Id
      , Object_Goods.GoodsCodeInt          AS GoodsCode
      , Object_Goods.GoodsName             AS GoodsName
      , Object_Goods.NDS                   AS NDS
      , Object_Measure.ValueData           AS MeasureName
      , MovementItem.Amount                AS Amount
      , MIFloat_Price.ValueData            AS Price
      , MIFloat_PriceSale.ValueData        AS PriceSale
      , MIFloat_ChangePercent.ValueData    AS ChangePercent
      , MIFloat_Summ.ValueData             AS AmountSumm
     
    FROM  MovementItem
        LEFT JOIN MovementItemFloat AS MIFloat_Price
                                    ON MIFloat_Price.MovementItemId = MovementItem.Id
                                   AND MIFloat_Price.DescId = zc_MIFloat_Price()
        LEFT JOIN MovementItemFloat AS MIFloat_PriceSale
                                    ON MIFloat_PriceSale.MovementItemId = MovementItem.Id
                                   AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()
        LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                    ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                   AND MIFloat_Summ.DescId = zc_MIFloat_Summ()
        LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                    ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                   AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()
        LEFT JOIN Object_Goods_View AS Object_Goods 
                                    ON Object_Goods.Id = MovementItem.ObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                             ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId 
                            AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
        LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

    WHERE MovementItem.MovementId = inMovementId
      AND MovementItem.DescId = zc_MI_Master()
      AND MovementItem.isErased   = FALSE
    ORDER BY Object_Goods.GoodsName ;
          
    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.     Воробкало А.А.
 20.03.17         *
*/
-- тест
--select * from gpSelect_Movement_Sale_Print(inMovementId := 3897397 ,  inSession := '3');
