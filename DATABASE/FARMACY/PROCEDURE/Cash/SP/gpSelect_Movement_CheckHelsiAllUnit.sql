-- Function: gpSelect_Movement_CheckHelsiAllUnit()

--DROP FUNCTION IF EXISTS gpSelect_Movement_CheckHelsiAllUnit (TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_CheckHelsiAllUnit (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_CheckHelsiAllUnit(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Ord Integer
             , ParentName TVarChar, UnitId integer, UnitCode integer, UnitName TVarChar
             , Id Integer, InvNumber TVarChar, OperDate TDateTime
             , TotalSumm TFloat
             , CashRegisterName TVarChar, PaidTypeName TVarChar
             , FiscalCheckNumber TVarChar
             , InvNumberSP TVarChar, ConfirmationCodeSP TVarChar
             , SPKindName TVarChar
             , MovementItemId Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Amount TFloat
             , Price TFloat
             , Summ TFloat
             , PriceSale TFloat
             , SummSale TFloat
             , MedicalProgramId TVarChar, CountSP TFloat, IdSP TVarChar, ProgramIdSP TVarChar, DosageIdSP TVarChar, PriceRetSP TFloat, PaymentSP TFloat
             , State TVarChar
             , Color_calc Integer
              )              
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);


     -- Результат
     RETURN QUERY
WITH -- Товары соц-проект
           tmpGoodsSP AS (SELECT MovementItem.ObjectId         AS GoodsId
                               , MI_IntenalSP.ObjectId         AS IntenalSPId
                               , MIFloat_PriceRetSP.ValueData  AS PriceRetSP
                               , MIFloat_PriceSP.ValueData     AS PriceSP
                               , MIFloat_PaymentSP.ValueData   AS PaymentSP
                               , MIFloat_CountSP.ValueData     AS CountSP
                               , MIString_IdSP.ValueData       AS IdSP
                               , COALESCE (MIString_ProgramIdSP.ValueData, '')::TVarChar AS ProgramIdSP
                               , MIString_DosageIdSP.ValueData AS DosageIdSP
                               , ObjectString_ProgramId.ValueData                        AS MedicalProgramId
                                                                -- № п/п - на всякий случай
                               , ROW_NUMBER() OVER (PARTITION BY MovementItem.ObjectId ORDER BY Movement.OperDate DESC) AS Ord
                          FROM Movement
                               INNER JOIN MovementDate AS MovementDate_OperDateStart
                                                       ON MovementDate_OperDateStart.MovementId = Movement.Id
                                                      AND MovementDate_OperDateStart.DescId     = zc_MovementDate_OperDateStart()
                                                      AND MovementDate_OperDateStart.ValueData  <= CURRENT_DATE

                               INNER JOIN MovementDate AS MovementDate_OperDateEnd
                                                       ON MovementDate_OperDateEnd.MovementId = Movement.Id
                                                      AND MovementDate_OperDateEnd.DescId     = zc_MovementDate_OperDateEnd()
                                                      AND MovementDate_OperDateEnd.ValueData  >= CURRENT_DATE

                               LEFT JOIN MovementLinkObject AS MLO_MedicalProgramSP
                                                            ON MLO_MedicalProgramSP.MovementId = Movement.Id
                                                           AND MLO_MedicalProgramSP.DescId = zc_MovementLink_MedicalProgramSP()
                               LEFT JOIN ObjectString AS ObjectString_ProgramId 	
                                                      ON ObjectString_ProgramId.ObjectId = MLO_MedicalProgramSP.ObjectId
                                                     AND ObjectString_ProgramId.DescId = zc_ObjectString_MedicalProgramSP_ProgramId()

                               LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                     AND MovementItem.DescId     = zc_MI_Master()
                                                     AND MovementItem.isErased   = FALSE

                               LEFT JOIN MovementItemLinkObject AS MI_IntenalSP
                                                                ON MI_IntenalSP.MovementItemId = MovementItem.Id
                                                               AND MI_IntenalSP.DescId = zc_MILinkObject_IntenalSP()
                               -- Роздрібна  ціна за упаковку, грн
                               LEFT JOIN MovementItemFloat AS MIFloat_PriceRetSP
                                                           ON MIFloat_PriceRetSP.MovementItemId = MovementItem.Id
                                                          AND MIFloat_PriceRetSP.DescId = zc_MIFloat_PriceRetSP()
                               -- Розмір відшкодування за упаковку (Соц. проект) - (15)
                               LEFT JOIN MovementItemFloat AS MIFloat_PriceSP
                                                           ON MIFloat_PriceSP.MovementItemId = MovementItem.Id
                                                          AND MIFloat_PriceSP.DescId = zc_MIFloat_PriceSP()
                               -- Сума доплати за упаковку, грн (Соц. проект) - 16)
                               LEFT JOIN MovementItemFloat AS MIFloat_PaymentSP
                                                           ON MIFloat_PaymentSP.MovementItemId = MovementItem.Id
                                                          AND MIFloat_PaymentSP.DescId = zc_MIFloat_PaymentSP()

                               -- Кількість одиниць лікарського засобу у споживчій упаковці (Соц. проект)(6)
                               LEFT JOIN MovementItemFloat AS MIFloat_CountSP
                                                           ON MIFloat_CountSP.MovementItemId = MovementItem.Id
                                                          AND MIFloat_CountSP.DescId = zc_MIFloat_CountSP()
                               -- ID лікарського засобу
                               LEFT JOIN MovementItemString AS MIString_IdSP
                                                            ON MIString_IdSP.MovementItemId = MovementItem.Id
                                                           AND MIString_IdSP.DescId = zc_MIString_IdSP()
                               LEFT JOIN MovementItemString AS MIString_ProgramIdSP
                                                            ON MIString_ProgramIdSP.MovementItemId = MovementItem.Id
                                                           AND MIString_ProgramIdSP.DescId = zc_MIString_ProgramIdSP()
                               -- DosageID лікарського засобу
                               LEFT JOIN MovementItemString AS MIString_DosageIdSP
                                                            ON MIString_DosageIdSP.MovementItemId = MovementItem.Id
                                                           AND MIString_DosageIdSP.DescId = zc_MIString_DosageIdSP()

                          WHERE Movement.DescId = zc_Movement_GoodsSP()
                            AND Movement.StatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete())
                         ),
           tmpMovement AS (SELECT Movement.*
                                , Object_Helsi_IdSP.ValueData                        AS SPKindName
                            FROM Movement
                           
                                INNER JOIN MovementLinkObject AS MovementLinkObject_SPKind
                                                              ON MovementLinkObject_SPKind.MovementId = Movement.Id
                                                             AND MovementLinkObject_SPKind.DescId = zc_MovementLinkObject_SPKind()

                                INNER JOIN Object AS Object_Helsi_IdSP
                                                  ON Object_Helsi_IdSP.DescId = zc_Object_SPKind()
                                                 AND Object_Helsi_IdSP.ObjectCode  = 1
                                                 AND Object_Helsi_IdSP.Id  = MovementLinkObject_SPKind.ObjectId

                           WHERE Movement.OperDate >= DATE_TRUNC ('DAY', inStartDate)
                             AND Movement.OperDate < DATE_TRUNC ('DAY', inEndDate) + INTERVAL '1 DAY'
                             AND Movement.DescId = zc_Movement_Check()
                             AND Movement.StatusId = zc_Enum_Status_Complete()
                           ), 
           tmpMovementLinkObject AS (SELECT * FROM MovementLinkObject 
                                     WHERE MovementLinkObject.MovementId IN (SELECT tmpMovement.Id FROM tmpMovement)), 
           tmpMovementString AS (SELECT * FROM MovementString
                                 WHERE MovementString.MovementId IN (SELECT tmpMovement.Id FROM tmpMovement)), 
           tmpMovementBoolean AS (SELECT * FROM MovementBoolean
                                 WHERE MovementBoolean.MovementId IN (SELECT tmpMovement.Id FROM tmpMovement))

      SELECT ROW_NUMBER() OVER (ORDER BY Object_Parent.ValueData, Object_Unit.ValueData, Movement.OperDate)::Integer AS Ord
           , Object_Parent.ValueData                            AS ParentName
           , Object_Unit.ID AS UnitID
           , Object_Unit.ObjectCode                             AS UnitCode
           , Object_Unit.ValueData                              AS UnitName
           , Movement.ID
           , Movement.InvNumber
           , Movement.OperDate
           , MovementFloat_TotalSumm.ValueData                  AS TotalSumm
           , Object_CashRegister.ValueData                      AS CashRegisterName
           , Object_PaidType.ValueData                          AS PaidTypeName
           , MovementString_FiscalCheckNumber.ValueData         AS FiscalCheckNumber
           , MovementString_InvNumberSP.ValueData               AS InvNumberSP
           , MovementString_ConfirmationCodeSP.ValueData        AS ConfirmationCodeSP
           , Movement.SPKindName                                AS SPKindName

           , MovementItem.Id                                    AS MovementItemId
           , MovementItem.ObjectId                              AS GoodsId
           , Object_Goods.goodscodeInt                          AS GoodsCode
           , Object_Goods.goodsname                             AS GoodsName
           , MovementItem.Amount
           , MIFloat_Price.ValueData             AS Price
           , zfCalc_SummaCheck(COALESCE (MovementItem.Amount, 0) * MIFloat_Price.ValueData
                             , COALESCE (MB_RoundingDown.ValueData, False)
                             , COALESCE (MB_RoundingTo10.ValueData, False)
                             , COALESCE (MB_RoundingTo50.ValueData, False)) AS AmountSumm

           , MIFloat_PriceSale.ValueData                                   AS PriceSale
           , (MIFloat_PriceSale.ValueData * MovementItem.Amount) :: TFloat AS SummSale

           , tmpGoodsSP.MedicalProgramId                            AS MedicalProgramId
           , tmpGoodsSP.CountSP                                     AS CountSP
           , tmpGoodsSP.IdSP                                        AS IdSP
           , tmpGoodsSP.ProgramIdSP                                 AS ProgramIdSP
           , tmpGoodsSP.DosageIdSP                                  AS DosageIdSP
           , tmpGoodsSP.PriceRetSP                                  AS PriceRetSP
           , tmpGoodsSP.PaymentSP                                   AS PaymentSP
           , NULL::TVarChar                                         AS State
           , zc_Color_White()                                       AS Color_calc

      FROM tmpMovement AS Movement

           INNER JOIN tmpMovementLinkObject AS MovementLinkObject_Unit
                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
           LEFT JOIN Object AS Object_Unit
                            ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId

           LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent
                                ON ObjectLink_Unit_Parent.ObjectId = Object_Unit.Id
                               AND ObjectLink_Unit_Parent.DescId = zc_ObjectLink_Unit_Parent()
           LEFT JOIN Object AS Object_Parent ON Object_Parent.Id = ObjectLink_Unit_Parent.ChildObjectId

           LEFT JOIN tmpMovementString AS MovementString_InvNumberSP
                                    ON MovementString_InvNumberSP.MovementId = Movement.Id
                                   AND MovementString_InvNumberSP.DescId = zc_MovementString_InvNumberSP()

           LEFT JOIN tmpMovementString AS MovementString_ConfirmationCodeSP
                                    ON MovementString_ConfirmationCodeSP.MovementId = Movement.Id
                                   AND MovementString_ConfirmationCodeSP.DescId = zc_MovementString_ConfirmationCodeSP()

           LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                   ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                  AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

           LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_CashRegister
                                        ON MovementLinkObject_CashRegister.MovementId = Movement.Id
                                       AND MovementLinkObject_CashRegister.DescId = zc_MovementLinkObject_CashRegister()
           LEFT JOIN Object AS Object_CashRegister ON Object_CashRegister.Id = MovementLinkObject_CashRegister.ObjectId

           LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_PaidType
                                        ON MovementLinkObject_PaidType.MovementId = Movement.Id
                                       AND MovementLinkObject_PaidType.DescId = zc_MovementLinkObject_PaidType()
           LEFT JOIN Object AS Object_PaidType ON Object_PaidType.Id = MovementLinkObject_PaidType.ObjectId

           LEFT JOIN tmpMovementString AS MovementString_FiscalCheckNumber
                                    ON MovementString_FiscalCheckNumber.MovementId = Movement.Id
                                   AND MovementString_FiscalCheckNumber.DescId = zc_MovementString_FiscalCheckNumber()

           LEFT JOIN tmpMovementBoolean AS MovementBoolean_PaperRecipeSP
                                     ON MovementBoolean_PaperRecipeSP.MovementId = Movement.Id
                                    AND MovementBoolean_PaperRecipeSP.DescId = zc_MovementBoolean_PaperRecipeSP()

           LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                 AND MovementItem.DescId     = zc_MI_Master()
                                 AND MovementItem.isErased   = FALSE   

           LEFT JOIN MovementItemFloat AS MIFloat_Price
                                       ON MIFloat_Price.MovementItemId = MovementItem.Id
                                      AND MIFloat_Price.DescId = zc_MIFloat_Price()
           LEFT JOIN MovementItemFloat AS MIFloat_PriceSale
                                       ON MIFloat_PriceSale.MovementItemId = MovementItem.Id
                                      AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()
           LEFT JOIN tmpMovementBoolean AS MB_RoundingTo10
                                     ON MB_RoundingTo10.MovementId = MovementItem.MovementId
                                    AND MB_RoundingTo10.DescId = zc_MovementBoolean_RoundingTo10()
           LEFT JOIN tmpMovementBoolean AS MB_RoundingDown
                                     ON MB_RoundingDown.MovementId = MovementItem.MovementId
                                    AND MB_RoundingDown.DescId = zc_MovementBoolean_RoundingDown()
           LEFT JOIN tmpMovementBoolean AS MB_RoundingTo50
                                     ON MB_RoundingTo50.MovementId = MovementItem.MovementId
                                    AND MB_RoundingTo50.DescId = zc_MovementBoolean_RoundingTo50()

           LEFT JOIN Object_Goods_View AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

           -- получается GoodsMainId
           LEFT JOIN  ObjectLink AS ObjectLink_Child ON ObjectLink_Child.ChildObjectId = MovementItem.ObjectId
                                                     AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
           LEFT JOIN  ObjectLink AS ObjectLink_Main ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                    AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
           -- Соц Проект
           LEFT JOIN tmpGoodsSP ON tmpGoodsSP.GoodsId = ObjectLink_Main.ChildObjectId
                               AND tmpGoodsSP.Ord     = 1 -- № п/п - на всякий случай
           LEFT JOIN  Object AS Object_IntenalSP ON Object_IntenalSP.Id = tmpGoodsSP.IntenalSPId                        

      WHERE MovementItem.Amount > 0
        AND MovementItem.IsErased = False
        AND COALESCE(MovementBoolean_PaperRecipeSP.ValueData, False) = False
      ORDER BY Object_Parent.ValueData, Object_Unit.ValueData, Movement.OperDate;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.  Шаблий О.В.
 17.05.19                                                                                    *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_CheckHelsiAllUnit (inStartDate:= '19.07.2021', inSession:= '3')

select * from gpSelect_Movement_CheckHelsiAllUnit(inStartDate := ('24.05.2022')::TDateTime, inEndDate := ('24.05.2022')::TDateTime,  inSession := '183242');