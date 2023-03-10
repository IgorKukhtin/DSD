-- Function: gpSelect_MedicalProgramSP_Goods()

DROP FUNCTION IF EXISTS gpSelect_MedicalProgramSP_Goods (Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MedicalProgramSP_Goods (
    IN inSPKindId            Integer   ,  -- ключ объекта <СП> 
    IN inMedicalProgramSPId  Integer   ,  -- ключ объекта <Программа> 
    IN inCashSessionId       TVarChar  ,  -- Сессия кассового места
    IN inSession             TVarChar     -- сессия пользователя
)

RETURNS TABLE (GoodsId Integer
             , MedicalProgramSPID Integer
             , PercentPayment TFloat 
             , IntenalSPId Integer

             , PriceRetSP TFloat
             , PriceSP TFloat
             , PaymentSP TFloat
             
             , CountSP TFloat
             , CountSPMin TFloat
             , IdSP TVarChar
             , ProgramIdSP TVarChar
             , DosageIdSP TVarChar
             , PriceSaleSP TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbObjectId Integer;
BEGIN
-- if inSession = '3' then return; end if;


    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);
    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' THEN
       vbUnitKey := '0';
    END IF;
    vbUnitId := vbUnitKey::Integer;
    
    -- сеть пользователя
    vbObjectId := COALESCE (lpGet_DefaultValue('zc_Object_Retail', vbUserId), '0');
    
    RETURN QUERY
    WITH -- Товары соц-проект
           tmpMedicalProgramSPUnit AS (SELECT  ObjectLink_MedicalProgramSP.ChildObjectId         AS MedicalProgramSPId
                                       FROM Object AS Object_MedicalProgramSPLink
                                            INNER JOIN ObjectLink AS ObjectLink_MedicalProgramSP
                                                                  ON ObjectLink_MedicalProgramSP.ObjectId = Object_MedicalProgramSPLink.Id
                                                                 AND ObjectLink_MedicalProgramSP.DescId = zc_ObjectLink_MedicalProgramSPLink_MedicalProgramSP()
                                                                 AND ObjectLink_MedicalProgramSP.ChildObjectId = inMedicalProgramSPId
                                            INNER JOIN ObjectLink AS ObjectLink_Unit
                                                                  ON ObjectLink_Unit.ObjectId = Object_MedicalProgramSPLink.Id
                                                                 AND ObjectLink_Unit.DescId = zc_ObjectLink_MedicalProgramSPLink_Unit()
                                                                 AND ObjectLink_Unit.ChildObjectId = vbUnitId 
                                        WHERE Object_MedicalProgramSPLink.DescId = zc_Object_MedicalProgramSPLink()
                                          AND Object_MedicalProgramSPLink.isErased = False)
         , tmpGoodsSP AS (SELECT Object_Goods_Retail.Id        AS GoodsId
                               , MLO_MedicalProgramSP.ObjectId AS MedicalProgramSPID 
                               , COALESCE(MovementFloat_PercentPayment.ValueData, 0)::TFloat  AS PercentPayment
                               , MI_IntenalSP.ObjectId         AS IntenalSPId
                               , MIFloat_PriceRetSP.ValueData  AS PriceRetSP
                               , MIFloat_PriceSP.ValueData     AS PriceSP
                               , MIFloat_PaymentSP.ValueData   AS PaymentSP
                               , MIFloat_CountSP.ValueData     AS CountSP
                               , MIFloat_CountSPMin.ValueData  AS CountSPMin
                               , MIString_IdSP.ValueData       AS IdSP
                               , COALESCE (MIString_ProgramIdSP.ValueData, '')::TVarChar AS ProgramIdSP
                               , MIString_DosageIdSP.ValueData AS DosageIdSP
                                                                -- № п/п - на всякий случай
                               , ROW_NUMBER() OVER (PARTITION BY MovementItem.ObjectId 
                                                    ORDER BY Movement.OperDate DESC, MIFloat_CountSPMin.ValueData DESC) AS Ord
                          FROM Movement
                               INNER JOIN MovementDate AS MovementDate_OperDateStart
                                                       ON MovementDate_OperDateStart.MovementId = Movement.Id
                                                      AND MovementDate_OperDateStart.DescId     = zc_MovementDate_OperDateStart()
                                                      AND MovementDate_OperDateStart.ValueData  <= CURRENT_DATE

                               INNER JOIN MovementDate AS MovementDate_OperDateEnd
                                                       ON MovementDate_OperDateEnd.MovementId = Movement.Id
                                                      AND MovementDate_OperDateEnd.DescId     = zc_MovementDate_OperDateEnd()
                                                      AND MovementDate_OperDateEnd.ValueData  >= CURRENT_DATE
                               INNER JOIN MovementLinkObject AS MLO_MedicalProgramSP
                                                             ON MLO_MedicalProgramSP.MovementId = Movement.Id
                                                            AND MLO_MedicalProgramSP.DescId = zc_MovementLink_MedicalProgramSP()
                               LEFT JOIN tmpMedicalProgramSPUnit ON tmpMedicalProgramSPUnit.MedicalProgramSPId = MLO_MedicalProgramSP.ObjectId

                               LEFT JOIN MovementFloat AS MovementFloat_PercentPayment
                                                       ON MovementFloat_PercentPayment.MovementId = Movement.Id
                                                      AND MovementFloat_PercentPayment.DescId = zc_MovementFloat_PercentPayment()

                               LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                     AND MovementItem.DescId     = zc_MI_Master()
                                                     AND MovementItem.isErased   = FALSE
                                                     
                               LEFT JOIN Object_Goods_Retail ON Object_Goods_Retail.GoodsMainId = MovementItem.ObjectId
                                                            AND Object_Goods_Retail.RetailId = vbObjectId

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

                               -- Мінімальна кількість форм випуску до продажу
                               LEFT JOIN MovementItemFloat AS MIFloat_CountSPMin
                                                           ON MIFloat_CountSPMin.MovementItemId = MovementItem.Id
                                                          AND MIFloat_CountSPMin.DescId = zc_MIFloat_CountSPMin()
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
                            AND (COALESCE (tmpMedicalProgramSPUnit.MedicalProgramSPId, 0) <> 0 
                             OR vbUserId = 3 AND MLO_MedicalProgramSP.ObjectId = inMedicalProgramSPId)
                          )
         , tmpCashSessionSnapShot AS (SELECT DISTINCT CashSessionSnapShot.ObjectId
                                           , CashSessionSnapShot.Price
                                      FROM CashSessionSnapShot
                                      WHERE CashSessionSnapShot.CashSessionId = inCashSessionId) 
                          
    SELECT tmpGoodsSP.GoodsId
         , tmpGoodsSP.MedicalProgramSPID
         , tmpGoodsSP.PercentPayment
         , tmpGoodsSP.IntenalSPId
         , tmpGoodsSP.PriceRetSP

            --
            -- Цена со скидкой для СП
            --
         ,  CASE WHEN COALESCE (tmpGoodsSP.PercentPayment, 0) > 0
                 THEN ROUND (CASE WHEN zfCalc_PriceCash(CashSessionSnapShot.Price, True) < COALESCE (tmpGoodsSP.PriceRetSP, 0)
                                  THEN zfCalc_PriceCash(CashSessionSnapShot.Price, True)
                                  ELSE COALESCE (tmpGoodsSP.PriceRetSP, 0) END * tmpGoodsSP.PercentPayment / 100, 2) -- Фиксированный % доплаты
                                       
                 WHEN COALESCE (tmpGoodsSP.PaymentSP, 0) = 0
                      THEN 0 -- по 0, т.к. цена доплаты = 0

                 WHEN zfCalc_PriceCash(CashSessionSnapShot.Price, True) < COALESCE (tmpGoodsSP.PriceSP, 0)
                      THEN 0 -- по 0, т.к. наша меньше чем цена возмещения

                 -- WHEN CashSessionSnapShot.Price < COALESCE (tmpGoodsSP.PaymentSP, 0)
                 --      THEN CashSessionSnapShot.Price -- по нашей цене, т.к. она меньше чем цена доплаты

                 WHEN zfCalc_PriceCash(CashSessionSnapShot.Price,True) < COALESCE (tmpGoodsSP.PriceSP, 0) + COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0)
                   AND 0 > COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0) -- "округлили в меньшую" и цену доплаты уменьшим на ...
                         - (COALESCE (CEIL (tmpGoodsSP.PriceSP * 100) / 100, 0) + COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0) 
                         - zfCalc_PriceCash(CashSessionSnapShot.Price, True)
                           ) -- разница с ценой возмещения и "округлили в большую"
                      THEN 0

                 WHEN zfCalc_PriceCash(CashSessionSnapShot.Price, True) < COALESCE (tmpGoodsSP.PriceSP, 0) + COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0)
                      THEN COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0) -- "округлили в меньшую" и цену доплаты уменьшим на ...
                         - (COALESCE (CEIL (tmpGoodsSP.PriceSP * 100) / 100, 0) + COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0) 
                         - zfCalc_PriceCash(CashSessionSnapShot.Price, True)
                           ) -- разница с ценой возмещения и "округлили в большую"

                 ELSE COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0) -- иначе всегда цена доплаты "округлили в меньшую"

            END :: TFloat AS PriceSP
         , tmpGoodsSP.PaymentSP
         , tmpGoodsSP.CountSP
         , tmpGoodsSP.CountSPMin
         , tmpGoodsSP.IdSP
         , tmpGoodsSP.ProgramIdSP
         , tmpGoodsSP.DosageIdSP

            --
            -- Цена без скидки для СП
            --
         , CASE WHEN COALESCE (tmpGoodsSP.PercentPayment, 0) > 0
                 THEN CASE WHEN zfCalc_PriceCash(CashSessionSnapShot.Price, True) < COALESCE (tmpGoodsSP.PriceRetSP, 0)
                           THEN zfCalc_PriceCash(CashSessionSnapShot.Price, True)
                           ELSE COALESCE (tmpGoodsSP.PriceRetSP, 0) END -- Фиксированный % доплаты
            ELSE
              CASE WHEN zfCalc_PriceCash(CashSessionSnapShot.Price, True) < COALESCE (tmpGoodsSP.PriceSP, 0)
                        THEN zfCalc_PriceCash(CashSessionSnapShot.Price, True) -- по нашей цене, т.к. она меньше чем цена возмещения

                   ELSE

              CASE WHEN COALESCE (tmpGoodsSP.PaymentSP, 0) = 0
                        THEN 0 -- по 0, т.к. цена доплаты = 0

                   WHEN zfCalc_PriceCash(CashSessionSnapShot.Price, True) < COALESCE (tmpGoodsSP.PriceSP, 0)
                        THEN 0 -- по 0, т.к. наша меньше чем цена возмещения

                   WHEN zfCalc_PriceCash(CashSessionSnapShot.Price, True) < COALESCE (tmpGoodsSP.PriceSP, 0) + COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0)
                     AND 0 > COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0) -- "округлили в меньшую" и цену доплаты уменьшим на ...
                           - (COALESCE (CEIL (tmpGoodsSP.PriceSP * 100) / 100, 0) + COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0) 
                           - zfCalc_PriceCash(CashSessionSnapShot.Price, True)
                             ) -- разница с ценой возмещения и "округлили в большую"
                        THEN 0

                   WHEN zfCalc_PriceCash(CashSessionSnapShot.Price, True) < COALESCE (tmpGoodsSP.PriceSP, 0) + COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0)
                        THEN COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0) -- "округлили в меньшую" и цену доплаты уменьшим на ...
                           - (COALESCE (CEIL (tmpGoodsSP.PriceSP * 100) / 100, 0) + COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0) 
                           - zfCalc_PriceCash(CashSessionSnapShot.Price, True)
                             ) -- разница с ценой возмещения и "округлили в большую"

                   ELSE COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0) -- иначе всегда цена доплаты "округлили в меньшую"

              END
            + COALESCE (tmpGoodsSP.PriceSP, 0)

            END END :: TFloat AS PriceSaleSP
    FROM tmpGoodsSP
    
         INNER JOIN tmpCashSessionSnapShot AS CashSessionSnapShot ON CashSessionSnapShot.ObjectId = tmpGoodsSP.GoodsId                                       
         
    WHERE tmpGoodsSP.Ord = 1;
                         
                         
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_MedicalProgramSP_Goods (Integer, Integer, TVarChar, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 31.07.19                                                       *
*/

-- 

select * from gpSelect_MedicalProgramSP_Goods(inSPKindId := 4823009 , inMedicalProgramSPId := 18078224 , inCashSessionId := '{B71CE2FC-A542-4586-BF14-D2EFEA1FCBD8}' ,  inSession := '3');
