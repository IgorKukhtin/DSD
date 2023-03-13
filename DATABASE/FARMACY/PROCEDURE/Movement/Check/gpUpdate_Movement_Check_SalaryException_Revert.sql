-- Function: gpUpdate_Movement_Check__SalaryException()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Check_SalaryException_Revert(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Check_SalaryException_Revert(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inisSalaryException   Boolean   , -- Исключение по ЗП сотруднику
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
  vbUserId := inSession;

  IF NOT EXISTS(SELECT 1
                FROM MovementBoolean
                WHERE MovementBoolean.DescId = zc_MovementBoolean_SalaryException()
                  AND MovementBoolean.MovementId = inMovementId
                  AND MovementBoolean.ValueData = NOT inisSalaryException) 
  THEN

    -- Меняем признак Исключение по ЗП сотруднику
    Perform lpInsertUpdate_MovementBoolean(zc_MovementBoolean_SalaryException(), inMovementId, NOT inisSalaryException);
    
    
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ApplicationAward(), inMovementId, T1.ApplicationAward)
     FROM (
       WITH tmpMovement_Check AS (SELECT Movement.*
                                       , MovementLinkObject_Unit.ObjectId                            AS UnitId
                                       , COALESCE (MovementBoolean_SalaryException.ValueData, FALSE) AS isSalaryException
                                  FROM Movement

                                       INNER JOIN MovementBoolean AS MovementBoolean_MobileFirstOrder
                                                                  ON MovementBoolean_MobileFirstOrder.MovementId = Movement.Id
                                                                 AND MovementBoolean_MobileFirstOrder.DescId = zc_MovementBoolean_MobileFirstOrder()
                                                                 AND MovementBoolean_MobileFirstOrder.ValueData = TRUE

                                       LEFT JOIN MovementBoolean AS MovementBoolean_SalaryException
                                                                 ON MovementBoolean_SalaryException.MovementId = Movement.Id
                                                                AND MovementBoolean_SalaryException.DescId = zc_MovementBoolean_SalaryException()

                                       LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                                    ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                                   AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()                                                                                    

                                  WHERE Movement.ID = inMovementId
                                 )
          , tmpEmployeeSchedule AS (SELECT DISTINCT
                                           Movement.OperDate                        AS OperDate
                                         , MovementItemMaster.ObjectId              AS UserId
                                         , MILinkObject_Unit.ObjectId               AS UnitId
                                        FROM Movement

                                             INNER JOIN MovementItem AS MovementItemMaster
                                                                     ON MovementItemMaster.MovementId = Movement.Id
                                                                    AND MovementItemMaster.DescId = zc_MI_Master()

                                             INNER JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                                               ON MILinkObject_Unit.MovementItemId = MovementItemMaster.Id
                                                                              AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()

                                        WHERE Movement.OperDate = date_trunc('Month', (SELECT tmpMovement_Check.OperDate FROM tmpMovement_Check))
                                          AND Movement.DescId = zc_Movement_EmployeeSchedule()
                                          AND Movement.StatusId <> zc_Enum_Status_Erased()),
            tmpGoodsDiscount AS (SELECT Object_Goods_Retail.Id                                    AS GoodsId
                                      , Object_Goods_Retail.GoodsMainId                           AS GoodsMainId
                                      , Object_Object.Id                                          AS DiscountExternalID
                                      , COALESCE(ObjectBoolean_StealthBonuses.ValueData, False)   AS isStealthBonuses 
                                      , ROW_NUMBER() OVER (PARTITION BY Object_Goods_Retail.GoodsMainId  ORDER BY COALESCE(ObjectBoolean_StealthBonuses.ValueData, False) DESC) AS ORD
                                 FROM Object AS Object_BarCode
                                      INNER JOIN ObjectLink AS ObjectLink_BarCode_Goods
                                                            ON ObjectLink_BarCode_Goods.ObjectId = Object_BarCode.Id
                                                           AND ObjectLink_BarCode_Goods.DescId = zc_ObjectLink_BarCode_Goods()
                                      INNER JOIN Object_Goods_Retail AS Object_Goods_Retail ON Object_Goods_Retail.Id = ObjectLink_BarCode_Goods.ChildObjectId

                                      LEFT JOIN ObjectLink AS ObjectLink_BarCode_Object
                                                           ON ObjectLink_BarCode_Object.ObjectId = Object_BarCode.Id
                                                          AND ObjectLink_BarCode_Object.DescId = zc_ObjectLink_BarCode_Object()
                                      LEFT JOIN Object AS Object_Object ON Object_Object.Id = ObjectLink_BarCode_Object.ChildObjectId

                                      LEFT JOIN ObjectBoolean AS ObjectBoolean_StealthBonuses
                                                              ON ObjectBoolean_StealthBonuses.ObjectId = Object_BarCode.Id
                                                             AND ObjectBoolean_StealthBonuses.DescId = zc_ObjectBoolean_BarCode_StealthBonuses()
                                 WHERE Object_BarCode.DescId = zc_Object_BarCode()
                                   AND Object_BarCode.isErased = False
                                 ),
            tmpCheckGoodsSpecial AS ( SELECT MovementItemContainer.MovementId
                                           , SUM(ROUND(-1 * MovementItemContainer.Amount * MovementItemContainer.Price, 2))      AS Summa
                                      FROM MovementItemContainer

                                           INNER JOIN Object_Goods_Retail ON Object_Goods_Retail.ID = MovementItemContainer.ObjectId_analyzer
                                                                                        
                                           INNER JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId
                                                                                             
                                           LEFT JOIN tmpGoodsDiscount ON tmpGoodsDiscount.GoodsMainId = Object_Goods_Main.Id
                                                                     AND tmpGoodsDiscount.ORD = 1

                                      WHERE MovementItemContainer.OperDate >= DATE_TRUNC ('DAY', (SELECT tmpMovement_Check.OperDate FROM tmpMovement_Check))
                                        AND MovementItemContainer.OperDate < DATE_TRUNC ('DAY', (SELECT tmpMovement_Check.OperDate FROM tmpMovement_Check)) + INTERVAL '1 DAY'
                                        AND MovementItemContainer.MovementDescId = zc_Movement_Check()
                                        AND MovementItemContainer.DescId = zc_MIContainer_Count()
                                        AND (COALESCE (Object_Goods_Retail.SummaWages, 0) <> 0
                                             OR COALESCE (Object_Goods_Retail.PercentWages, 0) <> 0
                                             OR COALESCE(Object_Goods_Main.isStealthBonuses, FALSE) = TRUE
                                             OR COALESCE(tmpGoodsDiscount.isStealthBonuses, FALSE) = TRUE OR 
                                               (COALESCE (Object_Goods_Retail.DiscontAmountSite, 0) > 0 OR
                                               COALESCE (Object_Goods_Retail.DiscontPercentSite, 0) > 0) 
                                               AND Object_Goods_Retail.DiscontSiteStart IS NOT NULL
                                               AND Object_Goods_Retail.DiscontSiteEnd IS NOT NULL  
                                               AND Object_Goods_Retail.DiscontSiteStart <= MovementItemContainer.OperDate
                                               AND Object_Goods_Retail.DiscontSiteEnd >= MovementItemContainer.OperDate)
                                      GROUP BY MovementItemContainer.MovementId),
              tmpMI_Check AS (SELECT Movement.Id      AS MovementId
                                   , MovementItem.Id  AS MovementItemId
                                   , MovementItem.Amount
                              FROM tmpMovement_Check AS Movement

                                   INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                          AND MovementItem.DescId = zc_MI_Master()
                                                          AND MovementItem.isErased = False

                                   INNER JOIN MovementItemLinkObject AS MI_PartionDateKind
                                                                     ON MI_PartionDateKind.MovementItemId = MovementItem.Id
                                                                    AND MI_PartionDateKind.DescId = zc_MILinkObject_PartionDateKind()
                                                                    AND MI_PartionDateKind.ObjectId <> zc_Enum_PartionDateKind_Good()

                           ),                                          
              tmpMI AS (SELECT MovementItem.MovementId
                             , SUM(COALESCE(ROUND(MovementItem.Amount * MIFloat_Price.ValueData, 2), 0))::TFloat       AS Summa
                             , SUM(COALESCE(ROUND(MovementItem.Amount * MIFloat_PriceSale.ValueData, 2), 0))::TFloat   AS SummaSale
                        FROM tmpMI_Check AS MovementItem
   
                             LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                         ON MIFloat_Price.MovementItemId = MovementItem.MovementItemId
                                                        AND MIFloat_Price.DescId = zc_MIFloat_Price()
                             LEFT JOIN MovementItemFloat AS MIFloat_PriceSale
                                                         ON MIFloat_PriceSale.MovementItemId = MovementItem.MovementItemId
                                                        AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()
                                                              
                        GROUP BY MovementItem.MovementId
                        )                                             


         SELECT       
             Movement_Check.Id
           , Movement_Check.InvNumber
           , Movement_Check.OperDate

           , MovementFloat_TotalCount.ValueData                 AS TotalCount
           , MovementFloat_TotalSumm.ValueData                  AS TotalSumm
           , MovementFloat_TotalSummChangePercent.ValueData     AS TotalSummChangePercent
           , Object_Unit.ValueData                              AS UnitName

           , MovementString_InvNumberOrder.ValueData
           
           , MovementFloat_MobileDiscount.ValueData             AS MobileDiscount
           , Object_UserReferals.ValueData                      AS UserReferalsName
           , Object_UnitUserReferals.ValueData                  AS UserUnitReferalsName
           , CASE WHEN (MovementFloat_TotalSumm.ValueData + COALESCE (MovementFloat_TotalSummChangePercent.ValueData, 0) - 
                       COALESCE(tmpMI.SummaSale, 0) - COALESCE(tmpCheckGoodsSpecial.Summa, 0) >= 199.50 OR
                       Movement_Check.isSalaryException = TRUE) AND
                       COALESCE (MovementLinkObject_UserReferals.ObjectId, 0) <> 0 AND
                       COALESCE (MovementLinkObject_DiscountExternal.ObjectId, 0) = 0 AND
                       Movement_Check.StatusId = zc_Enum_Status_Complete() THEN 
                       CASE WHEN MovementFloat_TotalSumm.ValueData - COALESCE(tmpMI.Summa, 0) - COALESCE(tmpCheckGoodsSpecial.Summa, 0) > 1000 
                            THEN ROUND((MovementFloat_TotalSumm.ValueData - COALESCE(tmpMI.Summa, 0) - COALESCE(tmpCheckGoodsSpecial.Summa, 0)) * 0.02, 2)
                            ELSE 20 END ELSE 0 END::TFloat  AS ApplicationAward
                            
           , COALESCE(MovementFloat_ApplicationAward.ValueData, 0)::TFloat      AS ApplicationAwardSave
           
        FROM tmpMovement_Check AS Movement_Check 
             
             LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = Movement_Check.UnitId

             LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                     ON MovementFloat_TotalCount.MovementId = Movement_Check.Id
                                    AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()
 
             LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                     ON MovementFloat_TotalSumm.MovementId =  Movement_Check.Id
                                    AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
             LEFT JOIN MovementFloat AS MovementFloat_TotalSummChangePercent
                                     ON MovementFloat_TotalSummChangePercent.MovementId =  Movement_Check.Id
                                    AND MovementFloat_TotalSummChangePercent.DescId = zc_MovementFloat_TotalSummChangePercent()

             LEFT JOIN MovementFloat AS MovementFloat_MobileDiscount
                                     ON MovementFloat_MobileDiscount.MovementId =  Movement_Check.Id
                                    AND MovementFloat_MobileDiscount.DescId = zc_MovementFloat_MobileDiscount()

             LEFT JOIN MovementFloat AS MovementFloat_ApplicationAward
                                     ON MovementFloat_ApplicationAward.MovementId =  Movement_Check.Id
                                    AND MovementFloat_ApplicationAward.DescId = zc_MovementFloat_ApplicationAward()

             LEFT JOIN MovementString AS MovementString_InvNumberOrder
                                      ON MovementString_InvNumberOrder.MovementId = Movement_Check.Id
                                     AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()

             LEFT JOIN MovementLinkObject AS MovementLinkObject_UserReferals
                                          ON MovementLinkObject_UserReferals.MovementId = Movement_Check.Id
                                         AND MovementLinkObject_UserReferals.DescId = zc_MovementLinkObject_UserReferals()
             LEFT JOIN Object AS Object_UserReferals ON Object_UserReferals.Id = MovementLinkObject_UserReferals.ObjectId
            
             LEFT JOIN tmpEmployeeSchedule ON tmpEmployeeSchedule.OperDate = date_trunc('Month', Movement_Check.OperDate)
                                          AND tmpEmployeeSchedule.UserId =MovementLinkObject_UserReferals.ObjectId 
             LEFT JOIN Object AS Object_UnitUserReferals ON Object_UnitUserReferals.Id = tmpEmployeeSchedule.UnitId
            
             LEFT JOIN MovementLinkObject AS MovementLinkObject_DiscountExternal
                                          ON MovementLinkObject_DiscountExternal.MovementId = Movement_Check.Id
                                         AND MovementLinkObject_DiscountExternal.DescId = zc_MILinkObject_DiscountExternal()

             LEFT JOIN tmpCheckGoodsSpecial ON tmpCheckGoodsSpecial.MovementId = Movement_Check.ID

             LEFT JOIN tmpMI ON tmpMI.MovementId = Movement_Check.Id
             
        WHERE CASE WHEN (MovementFloat_TotalSumm.ValueData + COALESCE (MovementFloat_TotalSummChangePercent.ValueData, 0) - 
              COALESCE(tmpMI.SummaSale, 0) - COALESCE(tmpCheckGoodsSpecial.Summa, 0) >= 199.50 OR
              Movement_Check.isSalaryException = TRUE) AND
              COALESCE (MovementLinkObject_UserReferals.ObjectId, 0) <> 0 AND
              COALESCE (MovementLinkObject_DiscountExternal.ObjectId, 0) = 0 AND
              Movement_Check.StatusId = zc_Enum_Status_Complete() THEN 
              CASE WHEN MovementFloat_TotalSumm.ValueData - COALESCE(tmpMI.Summa, 0) - COALESCE(tmpCheckGoodsSpecial.Summa, 0) > 1000 
                   THEN ROUND((MovementFloat_TotalSumm.ValueData - COALESCE(tmpMI.Summa, 0) - COALESCE(tmpCheckGoodsSpecial.Summa, 0)) * 0.02, 2)
                   ELSE 20 END ELSE 0 END <> COALESCE(MovementFloat_ApplicationAward.ValueData, 0)) AS T1
  ;
    
    
    -- сохранили протокол
    PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, False);
    
  END IF;

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Шаблий О.В.
 07.03.23                                                                    *
*/

-- тест
-- select * from gpUpdate_Movement_Check_SalaryException_Revert(inMovementId := 31229298 , inisSalaryException := 'False' ,  inSession := '3');